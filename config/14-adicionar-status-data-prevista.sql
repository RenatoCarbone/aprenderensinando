-- Adicionar colunas status e data_prevista na tabela financeiro
-- Execute este SQL no Supabase SQL Editor

-- 1. Remover a restrição NOT NULL da coluna data (para permitir lançamentos futuros)
ALTER TABLE financeiro 
ALTER COLUMN data DROP NOT NULL;

-- 2. Adicionar coluna status (concluido ou previsto)
ALTER TABLE financeiro 
ADD COLUMN IF NOT EXISTS status TEXT DEFAULT 'concluido' CHECK (status IN ('concluido', 'previsto'));

-- 3. Adicionar coluna data_prevista (para lançamentos futuros)
ALTER TABLE financeiro 
ADD COLUMN IF NOT EXISTS data_prevista DATE;

-- 4. Atualizar todos os registros existentes para 'concluido'
UPDATE financeiro 
SET status = 'concluido' 
WHERE status IS NULL;

-- 5. Criar índice para melhorar performance
CREATE INDEX IF NOT EXISTS idx_financeiro_status ON financeiro(status);
CREATE INDEX IF NOT EXISTS idx_financeiro_data_prevista ON financeiro(data_prevista);

-- Pronto! Agora a tabela está preparada para lançamentos futuros
