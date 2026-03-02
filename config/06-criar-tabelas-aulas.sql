-- ============================================
-- CRIAR TABELAS PARA SISTEMA DE AULAS
-- ============================================
-- Executar no Supabase SQL Editor
-- Data: 01/03/2026

-- Tabela de Aulas (registro geral da aula)
CREATE TABLE IF NOT EXISTS aulas (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  data DATE NOT NULL,
  horario TIME NOT NULL,
  conteudo_aplicado TEXT NOT NULL, -- O que foi aplicado na aula
  observacoes_gerais TEXT, -- Observações do dia (geral)
  profissional_id UUID REFERENCES auth.users(id),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabela de Presença e Observações Individuais
CREATE TABLE IF NOT EXISTS aulas_presenca (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  aula_id UUID REFERENCES aulas(id) ON DELETE CASCADE,
  paciente_id UUID REFERENCES pacientes(id) ON DELETE CASCADE,
  presente BOOLEAN DEFAULT false,
  observacoes_individuais TEXT, -- Observações específicas do aluno
  mensagem_responsavel TEXT, -- Mensagem para enviar ao responsável
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(aula_id, paciente_id) -- Um aluno só pode ter uma presença por aula
);

-- Índices para performance
CREATE INDEX IF NOT EXISTS idx_aulas_data ON aulas(data);
CREATE INDEX IF NOT EXISTS idx_aulas_profissional ON aulas(profissional_id);
CREATE INDEX IF NOT EXISTS idx_presenca_aula ON aulas_presenca(aula_id);
CREATE INDEX IF NOT EXISTS idx_presenca_paciente ON aulas_presenca(paciente_id);

-- RLS (Row Level Security)
ALTER TABLE aulas ENABLE ROW LEVEL SECURITY;
ALTER TABLE aulas_presenca ENABLE ROW LEVEL SECURITY;

-- Políticas de acesso para aulas
CREATE POLICY "Profissionais podem ver suas aulas"
  ON aulas FOR SELECT
  USING (auth.uid() = profissional_id);

CREATE POLICY "Profissionais podem criar aulas"
  ON aulas FOR INSERT
  WITH CHECK (auth.uid() = profissional_id);

CREATE POLICY "Profissionais podem atualizar suas aulas"
  ON aulas FOR UPDATE
  USING (auth.uid() = profissional_id);

-- Políticas de acesso para presença
CREATE POLICY "Profissionais podem ver presenças de suas aulas"
  ON aulas_presenca FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM aulas 
      WHERE aulas.id = aulas_presenca.aula_id 
      AND aulas.profissional_id = auth.uid()
    )
  );

CREATE POLICY "Profissionais podem registrar presenças"
  ON aulas_presenca FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM aulas 
      WHERE aulas.id = aulas_presenca.aula_id 
      AND aulas.profissional_id = auth.uid()
    )
  );

CREATE POLICY "Profissionais podem atualizar presenças"
  ON aulas_presenca FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM aulas 
      WHERE aulas.id = aulas_presenca.aula_id 
      AND aulas.profissional_id = auth.uid()
    )
  );

-- Comentários
COMMENT ON TABLE aulas IS 'Registro de aulas/atendimentos realizados';
COMMENT ON TABLE aulas_presenca IS 'Presença e observações individuais dos alunos nas aulas';

-- Verificar criação
SELECT 
  table_name, 
  (SELECT COUNT(*) FROM information_schema.columns WHERE table_name = t.table_name) as num_columns
FROM information_schema.tables t
WHERE table_name IN ('aulas', 'aulas_presenca')
ORDER BY table_name;
