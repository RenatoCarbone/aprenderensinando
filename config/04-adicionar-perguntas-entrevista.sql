-- Adicionar colunas para as 13 perguntas da entrevista inicial

-- Renomear colunas antigas para o novo padrão
ALTER TABLE pacientes RENAME COLUMN queixa_inicial TO pergunta_1;
ALTER TABLE pacientes RENAME COLUMN quando_comecou TO pergunta_2;
ALTER TABLE pacientes RENAME COLUMN como_se_sentem TO pergunta_3;
ALTER TABLE pacientes RENAME COLUMN expectativas_escola TO pergunta_4;

-- Adicionar novas colunas para perguntas 5 a 13
ALTER TABLE pacientes ADD COLUMN IF NOT EXISTS pergunta_5 TEXT;
ALTER TABLE pacientes ADD COLUMN IF NOT EXISTS pergunta_6 TEXT;
ALTER TABLE pacientes ADD COLUMN IF NOT EXISTS pergunta_7 TEXT;
ALTER TABLE pacientes ADD COLUMN IF NOT EXISTS pergunta_8 TEXT;
ALTER TABLE pacientes ADD COLUMN IF NOT EXISTS pergunta_9 TEXT;
ALTER TABLE pacientes ADD COLUMN IF NOT EXISTS pergunta_10 TEXT;
ALTER TABLE pacientes ADD COLUMN IF NOT EXISTS pergunta_11 TEXT;
ALTER TABLE pacientes ADD COLUMN IF NOT EXISTS pergunta_12 TEXT;
ALTER TABLE pacientes ADD COLUMN IF NOT EXISTS pergunta_13 TEXT;

-- Comentários para documentação
COMMENT ON COLUMN pacientes.pergunta_1 IS '1) QUEIXA LIVRE: Em que posso ajudá-los? Ou o que os trouxe até aqui?';
COMMENT ON COLUMN pacientes.pergunta_2 IS '2) Quando começou o problema?';
COMMENT ON COLUMN pacientes.pergunta_3 IS '3) Como vocês se sentem diante dessa dificuldade?';
COMMENT ON COLUMN pacientes.pergunta_4 IS '4) O que a escola relata sobre essa dificuldade?';
COMMENT ON COLUMN pacientes.pergunta_5 IS '5) Em casa, como é essa dificuldade relatada pela escola?';
COMMENT ON COLUMN pacientes.pergunta_6 IS '6) Fale-me em detalhes como é a rotina de seu filho desde a hora e acordar até a hora de dormir, durante uma semana.';
COMMENT ON COLUMN pacientes.pergunta_7 IS '7) Como ele se comporta ao fazer as lições de casa?';
COMMENT ON COLUMN pacientes.pergunta_8 IS '8) E como vocês reagem a esse comportamento?';
COMMENT ON COLUMN pacientes.pergunta_9 IS '9) Existe outro problema além desse?';
COMMENT ON COLUMN pacientes.pergunta_10 IS '10) Quais as qualidades de seu filho?';
COMMENT ON COLUMN pacientes.pergunta_11 IS '11) Tem outros filhos? Como eles são?';
COMMENT ON COLUMN pacientes.pergunta_12 IS '12) O que vocês esperam de mim e do meu trabalho?';
COMMENT ON COLUMN pacientes.pergunta_13 IS '13) Gostariam de acrescentar algo?';
