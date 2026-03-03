-- ========================================
-- LANÇAMENTOS FUTUROS
-- ========================================

-- Adicionar campos para lançamentos futuros
ALTER TABLE financeiro 
ADD COLUMN IF NOT EXISTS status VARCHAR(20) DEFAULT 'concluido',
ADD COLUMN IF NOT EXISTS data_prevista DATE,
ADD COLUMN IF NOT EXISTS recorrente BOOLEAN DEFAULT false;

COMMENT ON COLUMN financeiro.status IS 'concluido = já recebido/pago | previsto = agendado para o futuro';
COMMENT ON COLUMN financeiro.data_prevista IS 'Data prevista para receber/pagar (para lançamentos futuros)';
COMMENT ON COLUMN financeiro.recorrente IS 'Se é um lançamento que se repete mensalmente';

-- Índice para buscar lançamentos futuros
CREATE INDEX IF NOT EXISTS idx_financeiro_status ON financeiro(status);
CREATE INDEX IF NOT EXISTS idx_financeiro_data_prevista ON financeiro(data_prevista);

-- View para lançamentos futuros
CREATE OR REPLACE VIEW v_lancamentos_futuros AS
SELECT 
  id,
  tipo,
  valor,
  categoria,
  descricao,
  data_prevista,
  recorrente,
  usuario_id,
  created_at
FROM financeiro
WHERE status = 'previsto'
  AND data_prevista >= CURRENT_DATE
ORDER BY data_prevista ASC;

COMMENT ON VIEW v_lancamentos_futuros IS 'Lançamentos futuros ainda não concluídos';

-- View para histórico 12 meses
CREATE OR REPLACE VIEW v_historico_12_meses AS
SELECT 
  TO_CHAR(data, 'YYYY-MM') AS mes,
  TO_CHAR(data, 'Mon/YYYY') AS mes_formatado,
  SUM(CASE WHEN tipo = 'receita' THEN valor ELSE 0 END) AS total_receitas,
  SUM(CASE WHEN tipo = 'despesa' THEN valor ELSE 0 END) AS total_despesas,
  SUM(CASE WHEN tipo = 'receita' THEN valor ELSE -valor END) AS saldo_mes
FROM financeiro
WHERE status = 'concluido'
  AND data >= CURRENT_DATE - INTERVAL '12 months'
GROUP BY TO_CHAR(data, 'YYYY-MM'), TO_CHAR(data, 'Mon/YYYY')
ORDER BY mes DESC;

COMMENT ON VIEW v_historico_12_meses IS 'Resumo financeiro dos últimos 12 meses';
