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
          <a href="/dashboard.html" class="nav-item ${currentPage === 'dashboard' ? 'active' : ''}" title="Dashboard">
            <span class="nav-icon">🏠</span>
            <span>Dashboard</span>
          </a>
        </div>

        <div class="nav-section">
          <div class="nav-section-title">Alunos</div>
          <a href="/cadastro.html" class="nav-item ${currentPage === 'cadastro' ? 'active' : ''}" title="Novo Cadastro">
            <span class="nav-icon">➕</span>
            <span>Novo Cadastro</span>
          </a>
          <a href="/alunos.html" class="nav-item ${currentPage === 'alunos' ? 'active' : ''}" title="Ver Alunos">
            <span class="nav-icon">👥</span>
            <span>Ver Alunos</span>
          </a>
        </div>

        <div class="nav-section">
          <div class="nav-section-title">Aulas</div>
          <a href="/agenda.html" class="nav-item ${currentPage === 'agenda' ? 'active' : ''}" title="Agendar Aula">
            <span class="nav-icon">📅</span>
            <span>Agendar Aula</span>
          </a>
          <a href="/registrar-aula.html" class="nav-item ${currentPage === 'registrar-aula' ? 'active' : ''}" title="Nova Aula">
            <span class="nav-icon">📄</span>
            <span>Nova Aula</span>
          </a>
        </div>

        <div class="nav-section">
          <div class="nav-section-title">Documentos</div>
          <a href="/biblioteca.html" class="nav-item ${currentPage === 'biblioteca' ? 'active' : ''}" title="Biblioteca">
            <span class="nav-icon">📚</span>
            <span>Biblioteca</span>
          </a>
        </div>

        <div class="nav-section">
          <div class="nav-section-title">Financeiro</div>
          <a href="/financeiro.html" class="nav-item ${currentPage === 'financeiro' ? 'active' : ''}" title="Financeiro - Receitas">
            <span class="nav-icon">💰</span>
            <span>Receitas</span>
          </a>
        </div>
      </nav>

      <div style="padding: 1rem; border-top: 1px solid var(--border-light);">
        <button onclick="logout()" class="btn btn-ghost" style="width: 100%; display: flex; align-items: center; justify-content: center; gap: var(--spacing-sm);" title="Sair do Sistema">
          <span style="font-size: 1.25rem;">🚪</span>
          <span>Sair</span>
        </button>
      </div>
    </div>
  `;
}

export function renderHeader(pageTitle, pageIcon = '📄') {
  return `
    <div class="app-header">
      <div style="display: flex; align-items: center; gap: 1rem;">
        <button onclick="toggleSidebar()" class="btn" style="background: var(--primary); color: white; padding: 0.5rem 0.75rem; border-radius: 8px; display: flex; align-items: center; gap: 0.5rem;" title="Recolher/Expandir Menu">
          <span style="font-size: 1.25rem;">☰</span>
        </button>
        <h1 class="page-title" style="margin: 0;">
          <span>${pageIcon}</span>
          <span>${pageTitle}</span>
        </h1>
      </div>
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

// Função para recolher/expandir sidebar
window.toggleSidebar = function() {
  const sidebar = document.querySelector('.sidebar');
  const mainContent = document.querySelector('.main-content');
  
  if (!sidebar) return;
  
  sidebar.classList.toggle('sidebar-collapsed');
  
  // Salvar preferência no localStorage
  const isCollapsed = sidebar.classList.contains('sidebar-collapsed');
  localStorage.setItem('sidebarCollapsed', isCollapsed);
};

// Aplicar estado do sidebar ao carregar
window.addEventListener('DOMContentLoaded', () => {
  const isCollapsed = localStorage.getItem('sidebarCollapsed') === 'true';
  if (isCollapsed) {
    const sidebar = document.querySelector('.sidebar');
    if (sidebar) {
      sidebar.classList.add('sidebar-collapsed');
    }
  }
});
