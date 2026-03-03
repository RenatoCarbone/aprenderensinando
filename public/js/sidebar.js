// Componente de Sidebar - Aprender Ensinando

export function renderSidebar(currentPage = '') {
  return `
    <div class="sidebar">
      <div class="sidebar-header">
        <img src="/logo.png" alt="Logo" class="sidebar-logo">
        <div class="sidebar-title">Espaço<br>Multidisciplinar<br>Aprender Ensinando</div>
      </div>

      <nav class="sidebar-nav">
        <div class="nav-section">
          <div class="nav-section-title">Principal</div>
          <a href="/dashboard.html" class="nav-item ${currentPage === 'dashboard' ? 'active' : ''}">
            <span class="nav-icon">🏠</span>
            <span>Dashboard</span>
          </a>
        </div>

        <div class="nav-section">
          <div class="nav-section-title">Alunos</div>
          <a href="/cadastro.html" class="nav-item ${currentPage === 'cadastro' ? 'active' : ''}">
            <span class="nav-icon">➕</span>
            <span>Novo Cadastro</span>
          </a>
          <a href="/alunos.html" class="nav-item ${currentPage === 'alunos' ? 'active' : ''}">
            <span class="nav-icon">👥</span>
            <span>Ver Alunos</span>
          </a>
        </div>

        <div class="nav-section">
          <div class="nav-section-title">Aulas</div>
          <a href="/agenda.html" class="nav-item ${currentPage === 'agenda' ? 'active' : ''}">
            <span class="nav-icon">📅</span>
            <span>Agendar Aula</span>
          </a>
          <a href="/registrar-aula.html" class="nav-item ${currentPage === 'registrar-aula' ? 'active' : ''}">
            <span class="nav-icon">📚</span>
            <span>Nova Aula</span>
          </a>
        </div>

        <div class="nav-section">
          <div class="nav-section-title">Documentos</div>
          <a href="/biblioteca.html" class="nav-item ${currentPage === 'biblioteca' ? 'active' : ''}">
            <span class="nav-icon">📚</span>
            <span>Biblioteca</span>
          </a>
        </div>

        <div class="nav-section">
          <div class="nav-section-title">Financeiro</div>
          <a href="/financeiro.html" class="nav-item ${currentPage === 'financeiro' ? 'active' : ''}">
            <span class="nav-icon">💰</span>
            <span>Receitas</span>
          </a>
        </div>
      </nav>

      <div style="padding: 1rem; border-top: 1px solid var(--border-light);">
        <button onclick="logout()" class="btn btn-ghost" style="width: 100%;">
          <span>🚪</span>
          <span>Sair</span>
        </button>
      </div>
    </div>
  `;
}

export function renderHeader(pageTitle, pageIcon = '📄') {
  return `
    <div class="app-header">
      <h1 class="page-title">
        <span>${pageIcon}</span>
        <span>${pageTitle}</span>
      </h1>
      <div style="display: flex; align-items: center; gap: 1rem;">
        <div style="text-align: right;">
          <div style="font-size: 0.875rem; font-weight: 600; color: var(--text-primary);" id="userName">Carregando...</div>
          <div style="font-size: 0.75rem; color: var(--text-tertiary);">Professora</div>
        </div>
      </div>
    </div>
  `;
}

// Função de logout
window.logout = async function() {
  if (confirm('Deseja realmente sair?')) {
    const { supabase } = await import('./supabase.js');
    await supabase.auth.signOut();
    window.location.href = '/';
  }
};

// Carregar nome do usuário
export async function loadUserName() {
  try {
    const { supabase } = await import('./supabase.js');
    const { data: { user } } = await supabase.auth.getUser();
    if (user?.email) {
      const userName = user.email.split('@')[0];
      const element = document.getElementById('userName');
      if (element) {
        element.textContent = userName;
      }
    }
  } catch (error) {
    console.error('Erro ao carregar usuário:', error);
  }
}
