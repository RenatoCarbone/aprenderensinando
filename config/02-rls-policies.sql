-- ========================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- Garante que cada usuário veja apenas seus próprios dados
-- ========================================

-- Habilitar RLS em todas as tabelas
ALTER TABLE usuarios ENABLE ROW LEVEL SECURITY;
ALTER TABLE pacientes ENABLE ROW LEVEL SECURITY;
ALTER TABLE agendamentos ENABLE ROW LEVEL SECURITY;
ALTER TABLE sessoes ENABLE ROW LEVEL SECURITY;
ALTER TABLE financeiro ENABLE ROW LEVEL SECURITY;

-- ========================================
-- POLÍTICAS: usuarios
-- ========================================

-- Usuários podem ver e atualizar apenas seu próprio perfil
CREATE POLICY "Usuários podem ver seu próprio perfil"
  ON usuarios FOR SELECT
  USING (auth.uid() = id);

CREATE POLICY "Usuários podem atualizar seu próprio perfil"
  ON usuarios FOR UPDATE
  USING (auth.uid() = id);

CREATE POLICY "Usuários podem inserir seu próprio perfil"
  ON usuarios FOR INSERT
  WITH CHECK (auth.uid() = id);

-- ========================================
-- POLÍTICAS: pacientes
-- ========================================

CREATE POLICY "Usuários podem ver seus próprios pacientes"
  ON pacientes FOR SELECT
  USING (auth.uid() = usuario_id);

CREATE POLICY "Usuários podem inserir pacientes"
  ON pacientes FOR INSERT
  WITH CHECK (auth.uid() = usuario_id);

CREATE POLICY "Usuários podem atualizar seus próprios pacientes"
  ON pacientes FOR UPDATE
  USING (auth.uid() = usuario_id);

CREATE POLICY "Usuários podem deletar seus próprios pacientes"
  ON pacientes FOR DELETE
  USING (auth.uid() = usuario_id);

-- ========================================
-- POLÍTICAS: agendamentos
-- ========================================

CREATE POLICY "Usuários podem ver seus próprios agendamentos"
  ON agendamentos FOR SELECT
  USING (auth.uid() = usuario_id);

CREATE POLICY "Usuários podem inserir agendamentos"
  ON agendamentos FOR INSERT
  WITH CHECK (auth.uid() = usuario_id);

CREATE POLICY "Usuários podem atualizar seus próprios agendamentos"
  ON agendamentos FOR UPDATE
  USING (auth.uid() = usuario_id);

CREATE POLICY "Usuários podem deletar seus próprios agendamentos"
  ON agendamentos FOR DELETE
  USING (auth.uid() = usuario_id);

-- ========================================
-- POLÍTICAS: sessoes
-- ========================================

CREATE POLICY "Usuários podem ver suas próprias sessões"
  ON sessoes FOR SELECT
  USING (auth.uid() = usuario_id);

CREATE POLICY "Usuários podem inserir sessões"
  ON sessoes FOR INSERT
  WITH CHECK (auth.uid() = usuario_id);

CREATE POLICY "Usuários podem atualizar suas próprias sessões"
  ON sessoes FOR UPDATE
  USING (auth.uid() = usuario_id);

CREATE POLICY "Usuários podem deletar suas próprias sessões"
  ON sessoes FOR DELETE
  USING (auth.uid() = usuario_id);

-- ========================================
-- POLÍTICAS: financeiro
-- ========================================

CREATE POLICY "Usuários podem ver seus próprios lançamentos financeiros"
  ON financeiro FOR SELECT
  USING (auth.uid() = usuario_id);

CREATE POLICY "Usuários podem inserir lançamentos financeiros"
  ON financeiro FOR INSERT
  WITH CHECK (auth.uid() = usuario_id);

CREATE POLICY "Usuários podem atualizar seus próprios lançamentos"
  ON financeiro FOR UPDATE
  USING (auth.uid() = usuario_id);

CREATE POLICY "Usuários podem deletar seus próprios lançamentos"
  ON financeiro FOR DELETE
  USING (auth.uid() = usuario_id);
