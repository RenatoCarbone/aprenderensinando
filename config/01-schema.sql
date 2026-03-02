-- ========================================
-- APRENDER ENSINANDO - SCHEMA DO BANCO DE DADOS
-- ========================================

-- TABELA: usuarios
-- Armazena informações dos profissionais que usam o sistema
CREATE TABLE IF NOT EXISTS usuarios (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT UNIQUE NOT NULL,
  nome TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- TABELA: pacientes
-- Armazena dados dos pacientes/alunos
CREATE TABLE IF NOT EXISTS pacientes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  id_aluno TEXT UNIQUE NOT NULL,
  usuario_id UUID REFERENCES usuarios(id) ON DELETE CASCADE,
  
  -- Dados da criança
  nome TEXT NOT NULL,
  data_nascimento DATE NOT NULL,
  sexo CHAR(1) CHECK (sexo IN ('M', 'F')),
  nivel_escolar TEXT,
  serie_ano TEXT,
  escola TEXT,
  indicacao TEXT,
  
  -- Dados dos responsáveis
  nome_pai TEXT,
  nome_mae TEXT,
  nome_avo TEXT,
  nome_outro_responsavel TEXT,
  responsavel_principal TEXT,
  email TEXT,
  telefone TEXT,
  endereco TEXT,
  
  -- Entrevista inicial
  queixa_inicial TEXT,
  quando_comecou TEXT,
  como_se_sentem TEXT,
  expectativas_escola TEXT,
  observacoes TEXT,
  
  -- Controle
  primeira_aula_agendada BOOLEAN DEFAULT FALSE,
  ativo BOOLEAN DEFAULT TRUE,
  
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- TABELA: agendamentos
-- Armazena os agendamentos de atendimentos
CREATE TABLE IF NOT EXISTS agendamentos (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  paciente_id UUID REFERENCES pacientes(id) ON DELETE CASCADE,
  usuario_id UUID REFERENCES usuarios(id) ON DELETE CASCADE,
  
  data_hora TIMESTAMP WITH TIME ZONE NOT NULL,
  duracao INTEGER DEFAULT 60, -- em minutos
  observacoes TEXT,
  
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- TABELA: sessoes
-- Armazena registros de sessões/atendimentos realizados
CREATE TABLE IF NOT EXISTS sessoes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  paciente_id UUID REFERENCES pacientes(id) ON DELETE CASCADE,
  usuario_id UUID REFERENCES usuarios(id) ON DELETE CASCADE,
  
  data_sessao DATE NOT NULL,
  atividades_realizadas TEXT NOT NULL,
  observacoes TEXT NOT NULL,
  progressao TEXT,
  proximas_etapas TEXT,
  
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- TABELA: financeiro
-- Armazena lançamentos financeiros (receitas e despesas)
CREATE TABLE IF NOT EXISTS financeiro (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  usuario_id UUID REFERENCES usuarios(id) ON DELETE CASCADE,
  paciente_id UUID REFERENCES pacientes(id) ON DELETE SET NULL,
  
  tipo TEXT NOT NULL CHECK (tipo IN ('receita', 'despesa')),
  data DATE NOT NULL,
  valor DECIMAL(10, 2) NOT NULL,
  categoria TEXT NOT NULL,
  descricao TEXT NOT NULL,
  observacoes TEXT,
  
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ÍNDICES para melhor performance
CREATE INDEX IF NOT EXISTS idx_pacientes_usuario ON pacientes(usuario_id);
CREATE INDEX IF NOT EXISTS idx_pacientes_id_aluno ON pacientes(id_aluno);
CREATE INDEX IF NOT EXISTS idx_agendamentos_paciente ON agendamentos(paciente_id);
CREATE INDEX IF NOT EXISTS idx_agendamentos_data ON agendamentos(data_hora);
CREATE INDEX IF NOT EXISTS idx_sessoes_paciente ON sessoes(paciente_id);
CREATE INDEX IF NOT EXISTS idx_sessoes_data ON sessoes(data_sessao);
CREATE INDEX IF NOT EXISTS idx_financeiro_data ON financeiro(data);
CREATE INDEX IF NOT EXISTS idx_financeiro_tipo ON financeiro(tipo);

-- TRIGGERS para updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_usuarios_updated_at BEFORE UPDATE ON usuarios
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_pacientes_updated_at BEFORE UPDATE ON pacientes
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_agendamentos_updated_at BEFORE UPDATE ON agendamentos
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_sessoes_updated_at BEFORE UPDATE ON sessoes
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_financeiro_updated_at BEFORE UPDATE ON financeiro
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
