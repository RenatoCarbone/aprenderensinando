-- ========================================
-- FUNÇÕES AUXILIARES
-- ========================================

-- Função para criar perfil de usuário automaticamente após signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.usuarios (id, email, nome)
  VALUES (
    NEW.id,
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'nome', split_part(NEW.email, '@', 1))
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger para executar a função quando um novo usuário se registrar
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- Função para calcular idade a partir da data de nascimento
CREATE OR REPLACE FUNCTION calcular_idade(data_nascimento DATE)
RETURNS INTEGER AS $$
BEGIN
  RETURN DATE_PART('year', AGE(data_nascimento));
END;
$$ LANGUAGE plpgsql;

-- Função para obter estatísticas do dashboard
CREATE OR REPLACE FUNCTION get_dashboard_stats(user_id UUID)
RETURNS JSON AS $$
DECLARE
  stats JSON;
BEGIN
  SELECT json_build_object(
    'total_pacientes', (
      SELECT COUNT(*) FROM pacientes WHERE usuario_id = user_id
    ),
    'atendimentos_hoje', (
      SELECT COUNT(*) FROM agendamentos 
      WHERE usuario_id = user_id 
      AND DATE(data_hora) = CURRENT_DATE
    ),
    'atendimentos_mes', (
      SELECT COUNT(*) FROM agendamentos 
      WHERE usuario_id = user_id 
      AND DATE_TRUNC('month', data_hora) = DATE_TRUNC('month', CURRENT_DATE)
    ),
    'receita_mensal', (
      SELECT COALESCE(SUM(valor), 0) FROM financeiro 
      WHERE usuario_id = user_id 
      AND tipo = 'receita'
      AND DATE_TRUNC('month', data) = DATE_TRUNC('month', CURRENT_DATE)
    )
  ) INTO stats;
  
  RETURN stats;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
