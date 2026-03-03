-- ========================================
-- SISTEMA DE COBRANÇA E MENSALIDADES
-- ========================================

-- 1. Adicionar campos de cobrança na tabela pacientes
ALTER TABLE pacientes 
ADD COLUMN IF NOT EXISTS valor_aula DECIMAL(10,2),
ADD COLUMN IF NOT EXISTS dia_vencimento INTEGER,
ADD COLUMN IF NOT EXISTS forma_pagamento VARCHAR(50),
ADD COLUMN IF NOT EXISTS data_inicio_cobranca DATE,
ADD COLUMN IF NOT EXISTS cobranca_ativa BOOLEAN DEFAULT false;

COMMENT ON COLUMN pacientes.valor_aula IS 'Valor cobrado por aula em reais';
COMMENT ON COLUMN pacientes.dia_vencimento IS 'Dia do mês para vencimento (1-31)';
COMMENT ON COLUMN pacientes.forma_pagamento IS 'PIX, Dinheiro, Transferência, Cartão, etc';
COMMENT ON COLUMN pacientes.data_inicio_cobranca IS 'Data da primeira aula (início da cobrança)';
COMMENT ON COLUMN pacientes.cobranca_ativa IS 'Se está ativo e deve gerar cobranças';

-- 2. Criar tabela de mensalidades/cobranças
CREATE TABLE IF NOT EXISTS mensalidades (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  paciente_id UUID REFERENCES pacientes(id) ON DELETE CASCADE,
  usuario_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  
  -- Período
  data_inicio DATE NOT NULL,
  data_fim DATE NOT NULL,
  
  -- Valores
  total_aulas INTEGER NOT NULL DEFAULT 0,
  valor_aula DECIMAL(10,2) NOT NULL,
  valor_total DECIMAL(10,2) NOT NULL,
  
  -- Status
  status VARCHAR(20) NOT NULL DEFAULT 'pendente', -- pendente, pago, atrasado
  data_vencimento DATE NOT NULL,
  data_pagamento DATE,
  
  -- Metadados
  forma_pagamento VARCHAR(50),
  observacoes TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

COMMENT ON TABLE mensalidades IS 'Controle de mensalidades/cobranças por aluno';
COMMENT ON COLUMN mensalidades.status IS 'pendente = não pago | pago = recebido | atrasado = vencido e não pago';

-- ========================================
-- ÍNDICES PARA PERFORMANCE
-- ========================================

CREATE INDEX IF NOT EXISTS idx_mensalidades_paciente ON mensalidades(paciente_id);
CREATE INDEX IF NOT EXISTS idx_mensalidades_usuario ON mensalidades(usuario_id);
CREATE INDEX IF NOT EXISTS idx_mensalidades_status ON mensalidades(status);
CREATE INDEX IF NOT EXISTS idx_mensalidades_vencimento ON mensalidades(data_vencimento);
CREATE INDEX IF NOT EXISTS idx_pacientes_cobranca_ativa ON pacientes(cobranca_ativa) WHERE cobranca_ativa = true;

-- ========================================
-- RLS (ROW LEVEL SECURITY)
-- ========================================

ALTER TABLE mensalidades ENABLE ROW LEVEL SECURITY;

-- Políticas para mensalidades
CREATE POLICY "Usuários podem ver suas próprias mensalidades"
ON mensalidades FOR SELECT
USING (auth.uid() = usuario_id);

CREATE POLICY "Usuários podem inserir suas mensalidades"
ON mensalidades FOR INSERT
WITH CHECK (auth.uid() = usuario_id);

CREATE POLICY "Usuários podem atualizar suas mensalidades"
ON mensalidades FOR UPDATE
USING (auth.uid() = usuario_id);

CREATE POLICY "Usuários podem deletar suas mensalidades"
ON mensalidades FOR DELETE
USING (auth.uid() = usuario_id);

-- ========================================
-- FUNÇÃO PARA CALCULAR AULAS DO PERÍODO
-- ========================================

CREATE OR REPLACE FUNCTION calcular_aulas_periodo(
  p_paciente_id UUID,
  p_data_inicio DATE,
  p_data_fim DATE
)
RETURNS INTEGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  total_aulas INTEGER;
BEGIN
  -- Contar aulas realizadas (que têm registro em 'aulas')
  SELECT COUNT(*)
  INTO total_aulas
  FROM aulas
  WHERE paciente_id = p_paciente_id
    AND data >= p_data_inicio
    AND data <= p_data_fim;
  
  RETURN COALESCE(total_aulas, 0);
END;
$$;

COMMENT ON FUNCTION calcular_aulas_periodo IS 'Calcula quantas aulas foram realizadas em um período';

-- ========================================
-- FUNÇÃO PARA GERAR MENSALIDADES AUTOMÁTICAS
-- ========================================

CREATE OR REPLACE FUNCTION gerar_mensalidades_pendentes()
RETURNS TABLE (
  paciente_id UUID,
  paciente_nome VARCHAR,
  total_aulas INTEGER,
  valor_total DECIMAL,
  data_vencimento DATE
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  -- Esta função será chamada periodicamente para gerar cobranças
  -- Busca pacientes ativos com cobrança configurada
  RETURN QUERY
  SELECT 
    p.id,
    p.nome,
    calcular_aulas_periodo(p.id, p.data_inicio_cobranca, CURRENT_DATE)::INTEGER,
    (calcular_aulas_periodo(p.id, p.data_inicio_cobranca, CURRENT_DATE) * p.valor_aula)::DECIMAL,
    make_date(EXTRACT(YEAR FROM CURRENT_DATE)::INTEGER, EXTRACT(MONTH FROM CURRENT_DATE)::INTEGER, p.dia_vencimento)::DATE
  FROM pacientes p
  WHERE p.cobranca_ativa = true
    AND p.valor_aula IS NOT NULL
    AND p.dia_vencimento IS NOT NULL;
END;
$$;

-- ========================================
-- TRIGGER PARA ATUALIZAR updated_at
-- ========================================

CREATE OR REPLACE FUNCTION update_mensalidades_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER mensalidades_updated_at
BEFORE UPDATE ON mensalidades
FOR EACH ROW
EXECUTE FUNCTION update_mensalidades_updated_at();

-- ========================================
-- VIEW PARA COBRANÇAS PENDENTES
-- ========================================

CREATE OR REPLACE VIEW v_cobrancas_pendentes AS
SELECT 
  m.id,
  m.paciente_id,
  p.nome AS paciente_nome,
  p.nome_mae,
  p.telefone,
  m.data_inicio,
  m.data_fim,
  m.total_aulas,
  m.valor_aula,
  m.valor_total,
  m.data_vencimento,
  m.status,
  m.forma_pagamento,
  CASE 
    WHEN m.data_vencimento < CURRENT_DATE AND m.status = 'pendente' THEN 'atrasado'
    WHEN m.data_vencimento = CURRENT_DATE + 1 AND m.status = 'pendente' THEN 'vence_amanha'
    ELSE m.status
  END AS status_calculado,
  m.usuario_id
FROM mensalidades m
INNER JOIN pacientes p ON m.paciente_id = p.id
WHERE m.status != 'pago'
ORDER BY m.data_vencimento;

COMMENT ON VIEW v_cobrancas_pendentes IS 'View com todas cobranças pendentes e alertas de vencimento';
