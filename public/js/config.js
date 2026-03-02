// ========================================
// CONFIGURAÇÃO DO SUPABASE
// ========================================

const SUPABASE_CONFIG = {
  url: 'https://ukjxekdwumfxilphrrmb.supabase.co',
  anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVranhla2R3dW1meGlscGhycm1iIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzI0NjM1ODQsImV4cCI6MjA4ODAzOTU4NH0.c68Cp_HYU53aeSoZyNUM6RiHSDFq0Y0sPxJEAyq1nQk'
};

// Inicializar cliente Supabase
const supabase = window.supabase.createClient(
  SUPABASE_CONFIG.url,
  SUPABASE_CONFIG.anonKey
);

// ========================================
// FUNÇÕES DE AUTENTICAÇÃO
// ========================================

async function checkAuth() {
  const { data: { session } } = await supabase.auth.getSession();
  
  if (!session) {
    // Redirecionar para login se não estiver autenticado
    if (!window.location.pathname.includes('index.html') && !window.location.pathname.endsWith('/')) {
      window.location.href = '/index.html';
    }
    return null;
  }
  
  return session;
}

async function getUserProfile() {
  const session = await checkAuth();
  if (!session) return null;
  
  const { data, error } = await supabase
    .from('usuarios')
    .select('*')
    .eq('id', session.user.id)
    .single();
  
  if (error) {
    console.error('Erro ao buscar perfil:', error);
    return null;
  }
  
  return data;
}

async function logout() {
  const { error } = await supabase.auth.signOut();
  
  if (error) {
    console.error('Erro ao fazer logout:', error);
    return;
  }
  
  window.location.href = '/index.html';
}

// ========================================
// FUNÇÕES DE UTILIDADE
// ========================================

function showAlert(message, type = 'info') {
  const alertDiv = document.createElement('div');
  alertDiv.className = `alert alert-${type}`;
  alertDiv.textContent = message;
  
  const container = document.querySelector('.container') || document.body;
  container.insertBefore(alertDiv, container.firstChild);
  
  setTimeout(() => {
    alertDiv.remove();
  }, 5000);
}

function showLoading(show = true) {
  let loader = document.getElementById('loading-overlay');
  
  if (show && !loader) {
    loader = document.createElement('div');
    loader.id = 'loading-overlay';
    loader.style.cssText = `
      position: fixed;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background: rgba(0, 0, 0, 0.5);
      display: flex;
      align-items: center;
      justify-content: center;
      z-index: 9999;
    `;
    loader.innerHTML = '<div class="spinner"></div>';
    document.body.appendChild(loader);
  } else if (!show && loader) {
    loader.remove();
  }
}

function formatDate(date) {
  if (!date) return '';
  const d = new Date(date);
  return d.toLocaleDateString('pt-BR');
}

function formatDateTime(date) {
  if (!date) return '';
  const d = new Date(date);
  return d.toLocaleString('pt-BR');
}

function formatCurrency(value) {
  return new Intl.NumberFormat('pt-BR', {
    style: 'currency',
    currency: 'BRL'
  }).format(value || 0);
}

function calcularIdade(dataNascimento) {
  if (!dataNascimento) return null;
  
  const hoje = new Date();
  const nascimento = new Date(dataNascimento);
  let idade = hoje.getFullYear() - nascimento.getFullYear();
  const mes = hoje.getMonth() - nascimento.getMonth();
  
  if (mes < 0 || (mes === 0 && hoje.getDate() < nascimento.getDate())) {
    idade--;
  }
  
  return idade;
}

// ========================================
// EXPORTAR FUNÇÕES GLOBAIS
// ========================================

window.appConfig = {
  supabase,
  checkAuth,
  getUserProfile,
  logout,
  showAlert,
  showLoading,
  formatDate,
  formatDateTime,
  formatCurrency,
  calcularIdade
};
