-- ============================================
-- CONFIGURAR POLÍTICAS DO STORAGE (FOTOS)
-- ============================================
-- Executar no Supabase SQL Editor
-- Data: 02/03/2026

-- Permitir upload de fotos (usuários autenticados)
CREATE POLICY "Usuários podem fazer upload de fotos"
ON storage.objects
FOR INSERT
TO authenticated
WITH CHECK (bucket_id = 'fotos');

-- Permitir atualização de fotos (sobrescrever)
CREATE POLICY "Usuários podem atualizar fotos"
ON storage.objects
FOR UPDATE
TO authenticated
USING (bucket_id = 'fotos');

-- Permitir leitura pública (qualquer um pode ver as fotos)
CREATE POLICY "Fotos são públicas"
ON storage.objects
FOR SELECT
TO public
USING (bucket_id = 'fotos');

-- Permitir deletar suas próprias fotos
CREATE POLICY "Usuários podem deletar fotos"
ON storage.objects
FOR DELETE
TO authenticated
USING (bucket_id = 'fotos');
