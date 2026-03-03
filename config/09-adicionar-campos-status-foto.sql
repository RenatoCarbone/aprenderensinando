-- ============================================
-- ADICIONAR CAMPOS DE STATUS E FOTO
-- ============================================
-- Executar no Supabase SQL Editor
-- Data: 02/03/2026

-- Adicionar coluna de foto (URL da imagem no Supabase Storage)
ALTER TABLE pacientes 
ADD COLUMN IF NOT EXISTS foto_url TEXT;

-- Adicionar coluna de status
ALTER TABLE pacientes 
ADD COLUMN IF NOT EXISTS status TEXT DEFAULT 'ativo' CHECK (status IN ('ativo', 'inativo', 'concluido'));

-- Adicionar data de conclusão
ALTER TABLE pacientes 
ADD COLUMN IF NOT EXISTS data_conclusao DATE;

-- Adicionar motivo da conclusão
ALTER TABLE pacientes 
ADD COLUMN IF NOT EXISTS motivo_conclusao TEXT;

-- Comentários
COMMENT ON COLUMN pacientes.foto_url IS 'URL da foto do paciente no Supabase Storage';
COMMENT ON COLUMN pacientes.status IS 'Status: ativo, inativo ou concluido';
COMMENT ON COLUMN pacientes.data_conclusao IS 'Data em que finalizou o atendimento';
COMMENT ON COLUMN pacientes.motivo_conclusao IS 'Motivo da conclusão (problema resolvido, alta, etc)';

-- Índice para filtros
CREATE INDEX IF NOT EXISTS idx_pacientes_status ON pacientes(status);

-- Verificar colunas criadas
SELECT 
  column_name, 
  data_type, 
  column_default,
  is_nullable
FROM information_schema.columns 
WHERE table_name = 'pacientes' 
  AND column_name IN ('foto_url', 'status', 'data_conclusao', 'motivo_conclusao')
ORDER BY column_name;
