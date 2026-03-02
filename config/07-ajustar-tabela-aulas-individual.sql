-- ============================================
-- AJUSTAR TABELA AULAS PARA MODELO INDIVIDUAL
-- ============================================
-- Executar no Supabase SQL Editor
-- Data: 02/03/2026

-- Remover tabela aulas_presenca (não é mais necessária)
DROP TABLE IF EXISTS aulas_presenca;

-- Recriar tabela aulas para aulas individuais
DROP TABLE IF EXISTS aulas;

CREATE TABLE aulas (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  paciente_id UUID REFERENCES pacientes(id) ON DELETE CASCADE NOT NULL,
  agendamento_id UUID REFERENCES agendamentos(id) ON DELETE SET NULL,
  data DATE NOT NULL,
  horario TEXT NOT NULL,
  conteudo_aplicado TEXT NOT NULL, -- O que foi aplicado nesta aula
  observacoes_gerais TEXT, -- Observações sobre esta aula específica
  mensagem_responsavel TEXT, -- Mensagem para o responsável deste aluno
  profissional_id UUID REFERENCES auth.users(id) NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Índices para performance
CREATE INDEX idx_aulas_paciente ON aulas(paciente_id);
CREATE INDEX idx_aulas_profissional ON aulas(profissional_id);
CREATE INDEX idx_aulas_data ON aulas(data);
CREATE INDEX idx_aulas_agendamento ON aulas(agendamento_id);

-- RLS (Row Level Security)
ALTER TABLE aulas ENABLE ROW LEVEL SECURITY;

-- Políticas de acesso
CREATE POLICY "Profissionais podem ver suas aulas"
  ON aulas FOR SELECT
  USING (auth.uid() = profissional_id);

CREATE POLICY "Profissionais podem criar aulas"
  ON aulas FOR INSERT
  WITH CHECK (auth.uid() = profissional_id);

CREATE POLICY "Profissionais podem atualizar suas aulas"
  ON aulas FOR UPDATE
  USING (auth.uid() = profissional_id);

CREATE POLICY "Profissionais podem excluir suas aulas"
  ON aulas FOR DELETE
  USING (auth.uid() = profissional_id);

-- Comentários
COMMENT ON TABLE aulas IS 'Registro individual de aulas/atendimentos por paciente';
COMMENT ON COLUMN aulas.paciente_id IS 'Paciente/aluno desta aula';
COMMENT ON COLUMN aulas.agendamento_id IS 'Agendamento que originou esta aula (opcional)';
COMMENT ON COLUMN aulas.conteudo_aplicado IS 'Atividades e conteúdo trabalhado nesta aula';
COMMENT ON COLUMN aulas.observacoes_gerais IS 'Observações sobre desempenho, comportamento, evolução';
COMMENT ON COLUMN aulas.mensagem_responsavel IS 'Mensagem que será enviada ao responsável';

-- Verificar criação
SELECT 
  column_name, 
  data_type, 
  is_nullable 
FROM information_schema.columns 
WHERE table_name = 'aulas'
ORDER BY ordinal_position;
