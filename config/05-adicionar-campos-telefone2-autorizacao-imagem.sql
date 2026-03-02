-- ============================================
-- ADICIONAR NOVOS CAMPOS NA TABELA PACIENTES
-- ============================================
-- Executar no Supabase SQL Editor
-- Data: 01/03/2026

-- Adicionar coluna telefone2 (telefone secundário)
ALTER TABLE pacientes 
ADD COLUMN IF NOT EXISTS telefone2 TEXT;

-- Adicionar coluna autorizacao_imagem (checkbox de autorização)
ALTER TABLE pacientes 
ADD COLUMN IF NOT EXISTS autorizacao_imagem BOOLEAN DEFAULT false;

-- Comentários nas colunas (documentação)
COMMENT ON COLUMN pacientes.telefone2 IS 'Telefone secundário do responsável';
COMMENT ON COLUMN pacientes.autorizacao_imagem IS 'Autorização para uso de imagem nas redes sociais';

-- Verificar se as colunas foram criadas
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'pacientes' 
  AND column_name IN ('telefone2', 'autorizacao_imagem')
ORDER BY column_name;
