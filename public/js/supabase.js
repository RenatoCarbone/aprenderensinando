// Módulo Supabase - Aprender Ensinando
// Importar a biblioteca Supabase
import { createClient } from 'https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2/+esm';

// Configurações do Supabase
const SUPABASE_URL = 'https://ukjxekdwumfxilphrrmb.supabase.co';
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVranhla2R3dW1meGlscGhycm1iIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzI0NjM1ODQsImV4cCI6MjA4ODAzOTU4NH0.c68Cp_HYU53aeSoZyNUM6RiHSDFq0Y0sPxJEAyq1nQk';

// Criar cliente Supabase
export const supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
