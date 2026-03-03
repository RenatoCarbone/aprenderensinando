-- ========================================
-- TABELAS PARA SISTEMA DE DOCUMENTOS
-- ========================================

-- 1. Tabela para Biblioteca de Documentos (modelos/templates gerais)
CREATE TABLE IF NOT EXISTS documentos_biblioteca (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  titulo VARCHAR(255) NOT NULL,
  nome_arquivo VARCHAR(255) NOT NULL,
  caminho_storage TEXT NOT NULL,
  tipo_arquivo VARCHAR(50),
  tamanho_bytes BIGINT,
  usuario_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. Tabela para Documentos dos Alunos (específicos por aluno)
CREATE TABLE IF NOT EXISTS documentos_alunos (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  paciente_id UUID REFERENCES pacientes(id) ON DELETE CASCADE,
  titulo VARCHAR(255) NOT NULL,
  nome_arquivo VARCHAR(255) NOT NULL,
  caminho_storage TEXT NOT NULL,
  tipo_arquivo VARCHAR(50),
  tamanho_bytes BIGINT,
  usuario_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ========================================
-- ÍNDICES PARA PERFORMANCE
-- ========================================

CREATE INDEX IF NOT EXISTS idx_documentos_biblioteca_usuario 
ON documentos_biblioteca(usuario_id);

CREATE INDEX IF NOT EXISTS idx_documentos_alunos_paciente 
ON documentos_alunos(paciente_id);

CREATE INDEX IF NOT EXISTS idx_documentos_alunos_usuario 
ON documentos_alunos(usuario_id);

-- ========================================
-- RLS (ROW LEVEL SECURITY)
-- ========================================

-- Habilitar RLS
ALTER TABLE documentos_biblioteca ENABLE ROW LEVEL SECURITY;
ALTER TABLE documentos_alunos ENABLE ROW LEVEL SECURITY;

-- Políticas para documentos_biblioteca
CREATE POLICY "Usuários podem ver seus próprios documentos da biblioteca"
ON documentos_biblioteca FOR SELECT
USING (auth.uid() = usuario_id);

CREATE POLICY "Usuários podem inserir documentos na biblioteca"
ON documentos_biblioteca FOR INSERT
WITH CHECK (auth.uid() = usuario_id);

CREATE POLICY "Usuários podem atualizar seus próprios documentos da biblioteca"
ON documentos_biblioteca FOR UPDATE
USING (auth.uid() = usuario_id);

CREATE POLICY "Usuários podem deletar seus próprios documentos da biblioteca"
ON documentos_biblioteca FOR DELETE
USING (auth.uid() = usuario_id);

-- Políticas para documentos_alunos
CREATE POLICY "Usuários podem ver documentos dos seus alunos"
ON documentos_alunos FOR SELECT
USING (auth.uid() = usuario_id);

CREATE POLICY "Usuários podem inserir documentos nos seus alunos"
ON documentos_alunos FOR INSERT
WITH CHECK (auth.uid() = usuario_id);

CREATE POLICY "Usuários podem atualizar documentos dos seus alunos"
ON documentos_alunos FOR UPDATE
USING (auth.uid() = usuario_id);

CREATE POLICY "Usuários podem deletar documentos dos seus alunos"
ON documentos_alunos FOR DELETE
USING (auth.uid() = usuario_id);

-- ========================================
-- CONFIGURAR STORAGE NO SUPABASE
-- ========================================

-- IMPORTANTE: Execute isso manualmente no Supabase Storage:
-- 
-- 1. Criar bucket "documentos" (público para download)
--    - No Supabase Dashboard: Storage > New Bucket
--    - Nome: documentos
--    - Public: true (para permitir download)
--
-- 2. Criar políticas de storage:

-- Política de SELECT (download)
CREATE POLICY "Usuários podem baixar seus documentos"
ON storage.objects FOR SELECT
USING (bucket_id = 'documentos' AND auth.uid()::text = (storage.foldername(name))[1]);

-- Política de INSERT (upload)
CREATE POLICY "Usuários podem fazer upload de documentos"
ON storage.objects FOR INSERT
WITH CHECK (bucket_id = 'documentos' AND auth.uid()::text = (storage.foldername(name))[1]);

-- Política de DELETE
CREATE POLICY "Usuários podem deletar seus documentos"
ON storage.objects FOR DELETE
USING (bucket_id = 'documentos' AND auth.uid()::text = (storage.foldername(name))[1]);

-- ========================================
-- ESTRUTURA DE PASTAS NO STORAGE:
-- ========================================
-- 
-- documentos/
--   ├── {usuario_id}/
--   │   ├── biblioteca/
--   │   │   ├── modelo-laudo.pdf
--   │   │   ├── licao-alfabeto.docx
--   │   │   └── teste-avaliacao.pdf
--   │   └── alunos/
--   │       ├── {paciente_id}/
--   │       │   ├── laudo-final-joao.pdf
--   │       │   ├── avaliacao-inicial.pdf
--   │       │   └── licao-01.docx
--   │       └── ...
