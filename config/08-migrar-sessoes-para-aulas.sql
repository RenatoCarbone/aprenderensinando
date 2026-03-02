-- ============================================
-- MIGRAR DADOS DE SESSOES PARA AULAS
-- ============================================
-- Executar no Supabase SQL Editor
-- Data: 02/03/2026

-- Inserir todas as sessões existentes na tabela aulas
INSERT INTO aulas (
  paciente_id,
  agendamento_id,
  data,
  horario,
  conteudo_aplicado,
  observacoes_gerais,
  mensagem_responsavel,
  profissional_id,
  created_at,
  updated_at
)
SELECT 
  s.paciente_id,
  NULL as agendamento_id, -- Sessões antigas não tinham agendamento vinculado
  s.data_sessao as data,
  '00:00' as horario, -- Sessões antigas não tinham horário específico
  s.atividades_realizadas as conteudo_aplicado,
  CASE 
    WHEN s.observacoes IS NOT NULL AND s.progressao IS NOT NULL THEN 
      s.observacoes || E'\n\nProgressão: ' || s.progressao
    WHEN s.observacoes IS NOT NULL THEN 
      s.observacoes
    WHEN s.progressao IS NOT NULL THEN 
      'Progressão: ' || s.progressao
    ELSE NULL
  END as observacoes_gerais,
  s.proximas_etapas as mensagem_responsavel,
  s.usuario_id as profissional_id,
  s.created_at,
  s.updated_at
FROM sessoes s
WHERE NOT EXISTS (
  -- Evitar duplicatas: só migra se não existir aula com mesma data e paciente
  SELECT 1 FROM aulas a 
  WHERE a.paciente_id = s.paciente_id 
  AND a.data = s.data_sessao
);

-- Verificar quantos registros foram migrados
SELECT 
  'Total de sessões migradas:' as info,
  COUNT(*) as quantidade
FROM aulas 
WHERE agendamento_id IS NULL;

-- Mostrar comparação
SELECT 
  'Tabela sessoes' as tabela,
  COUNT(*) as total_registros
FROM sessoes
UNION ALL
SELECT 
  'Tabela aulas' as tabela,
  COUNT(*) as total_registros
FROM aulas
ORDER BY tabela;

-- OPCIONAL: Após verificar que está tudo OK, você pode apagar a tabela sessoes
-- CUIDADO: Só execute isso se tiver certeza que migrou tudo!
-- DROP TABLE sessoes;
