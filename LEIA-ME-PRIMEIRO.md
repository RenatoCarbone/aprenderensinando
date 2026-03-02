# 📚 DOCUMENTAÇÃO COMPLETA DO PROJETO - APRENDER ENSINANDO

## 🎯 SOBRE O PROJETO

**Nome:** Aprender Ensinando - Sistema de Gestão Psicopedagógica

**Objetivo:** Sistema web completo para gestão de clínica psicopedagógica, desenvolvido para auxiliar profissionais no gerenciamento de pacientes, agendamentos, sessões e controle financeiro.

**Cliente:** Priscila Carbone (psicopedagoga)

**Desenvolvedor:** Renato Carbone

**Data de Criação:** Março de 2026

---

## 🌐 LINKS IMPORTANTES

- **Site em Produção:** https://aprenderensinando.pages.dev/
- **Repositório GitHub:** https://github.com/RenatoCarbone/aprenderensinando
- **Supabase (Banco de Dados):** https://supabase.com/dashboard/project/ukjxekdwumfxilphrrmb
- **Cloudflare Pages (Hospedagem):** Acessar via dash.cloudflare.com

---

## 🔑 CREDENCIAIS

### Supabase
- **URL:** `https://ukjxekdwumfxilphrrmb.supabase.co`
- **Anon Key:** `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVranhla2R3dW1meGlscGhycm1iIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzI0NjM1ODQsImV4cCI6MjA4ODAzOTU4NH0.c68Cp_HYU53aeSoZyNUM6RiHSDFq0Y0sPxJEAyq1nQk`

### Usuário de Teste
- **Email:** teste@teste.com
- **Senha:** 123456

---

## 🏗️ ARQUITETURA DO PROJETO

### Stack Tecnológica
- **Frontend:** HTML5, CSS3, JavaScript Vanilla (sem frameworks)
- **Banco de Dados:** Supabase (PostgreSQL + Auth)
- **Hospedagem:** Cloudflare Pages
- **Versionamento:** GitHub
- **Deploy:** Automático via GitHub → Cloudflare

### Estrutura de Pastas
```
PROJETO APRENDER ENSINANDO/
├── public/                      # Arquivos da aplicação web
│   ├── index.html              # Página de login ✅
│   ├── dashboard.html          # Dashboard principal ✅
│   ├── cadastro.html           # Cadastro de pacientes + entrevista ✅
│   ├── alunos.html             # Lista e detalhes de pacientes ✅
│   ├── agenda.html             # Sistema de agendamentos ✅
│   ├── sessao.html             # Registro de sessões/atendimentos ✅
│   ├── financeiro.html         # Controle financeiro ✅
│   ├── css/
│   │   └── styles.css          # Estilos globais (cores neutras)
│   ├── js/
│   │   └── (config.js foi DELETADO - não usar!)
│   ├── _headers                # Headers de segurança HTTP
│   └── favicon.ico             # Ícone do site
│
├── config/                      # Scripts SQL do Supabase
│   ├── 01-schema.sql           # Criação das tabelas
│   ├── 02-rls-policies.sql     # Políticas de segurança
│   └── 03-functions.sql        # Funções auxiliares
│
├── prints/                      # Screenshots e documentação visual
│
├── LEIA-ME-PRIMEIRO.md         # 👈 ESTE ARQUIVO
├── README.md                   # Documentação geral
├── GUIA-CONFIGURACAO.md        # Passo a passo de setup
├── GUIA-USO-SISTEMA.md         # Como usar o sistema
├── INSTRUCOES-RAPIDAS.md       # Quick start
├── .gitignore                  # Arquivos ignorados pelo Git
├── .env.example                # Exemplo de variáveis de ambiente
└── wrangler.toml               # (DELETADO - era para Workers, não Pages)
```

---

## 🗄️ BANCO DE DADOS (SUPABASE)

### Tabelas Criadas

#### 1. **usuarios**
Armazena dados dos profissionais que usam o sistema
- `id` (UUID, PK) - Referência para auth.users
- `email` (TEXT)
- `nome` (TEXT)
- `created_at`, `updated_at`

#### 2. **pacientes**
Dados completos dos pacientes/crianças
- `id` (UUID, PK)
- `id_aluno` (TEXT) - Ex: ALU-001, ALU-002...
- `usuario_id` (UUID, FK → usuarios)
- **Dados da criança:** nome, data_nascimento, sexo, nivel_escolar, serie_ano, escola, indicacao
- **Responsáveis:** nome_pai, nome_mae, nome_avo, nome_outro_responsavel, responsavel_principal, email, telefone, endereco
- **Entrevista inicial:** queixa_inicial, quando_comecou, como_se_sentem, expectativas_escola, observacoes
- **Controle:** primeira_aula_agendada, ativo
- `created_at`, `updated_at`

#### 3. **agendamentos**
Agendamentos de atendimentos
- `id` (UUID, PK)
- `paciente_id` (UUID, FK → pacientes)
- `usuario_id` (UUID, FK → usuarios)
- `data_hora` (TIMESTAMP)
- `duracao` (INTEGER) - em minutos
- `observacoes` (TEXT)
- `created_at`, `updated_at`

#### 4. **sessoes**
Registros de sessões/atendimentos realizados
- `id` (UUID, PK)
- `paciente_id` (UUID, FK → pacientes)
- `usuario_id` (UUID, FK → usuarios)
- `data_sessao` (DATE)
- `atividades_realizadas` (TEXT)
- `observacoes` (TEXT)
- `progressao` (TEXT)
- `proximas_etapas` (TEXT)
- `created_at`, `updated_at`

#### 5. **financeiro**
Lançamentos financeiros (receitas e despesas)
- `id` (UUID, PK)
- `usuario_id` (UUID, FK → usuarios)
- `paciente_id` (UUID, FK → pacientes, nullable)
- `tipo` (TEXT) - 'receita' ou 'despesa'
- `data` (DATE)
- `valor` (DECIMAL)
- `categoria` (TEXT)
- `descricao` (TEXT)
- `observacoes` (TEXT)
- `created_at`, `updated_at`

### Row Level Security (RLS)
✅ **ATIVADO** em todas as tabelas

Cada usuário vê **APENAS seus próprios dados**:
- Pacientes criados por ele
- Agendamentos criados por ele
- Sessões criadas por ele
- Lançamentos financeiros criados por ele

---

## ⚙️ COMO O CÓDIGO FUNCIONA

### ⚠️ IMPORTANTE: Inicialização do Supabase

**TODAS as páginas HTML** inicializam o Supabase da MESMA forma:

```javascript
<script src="https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2"></script>
<script>
  const sb = window.supabase.createClient(
    'https://ukjxekdwumfxilphrrmb.supabase.co',
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...'
  );
  
  // Funções auxiliares inline
  async function checkAuth() { ... }
  async function logout() { ... }
  function formatDate(d) { ... }
  // etc
</script>
```

**🚨 NUNCA use `const supabase` - SEMPRE use `const sb`!**

**🚨 NÃO existe mais o arquivo `/js/config.js` - foi deletado!**

### Por que `sb` em vez de `supabase`?

Porque a biblioteca Supabase cria um objeto global `window.supabase` e tentar declarar `const supabase` causava conflito de "identifier already declared". Usar `sb` resolve isso.

### Autenticação

Todas as páginas (exceto index.html) verificam autenticação:

```javascript
(async () => {
  const session = await checkAuth();
  if (!session) return; // Redireciona para /index.html
  
  // Buscar dados do usuário
  const { data } = await sb.from('usuarios').select('*').eq('id', session.user.id).single();
  currentUser = data;
})();
```

### Logout

Todas as páginas têm botão de logout que chama:

```javascript
async function logout() {
  await sb.auth.signOut();
  window.location.href = '/index.html';
}
```

---

## 🎨 DESIGN E ESTILOS

### Cores (Neutras e Profissionais)

Definidas em `/public/css/styles.css`:

```css
:root {
  --primary: #2c3e50;        /* Azul escuro */
  --secondary: #95a5a6;      /* Cinza */
  --accent: #3498db;         /* Azul claro */
  --success: #27ae60;        /* Verde */
  --warning: #f39c12;        /* Laranja */
  --danger: #e74c3c;         /* Vermelho */
  --bg-primary: #ffffff;     /* Branco */
  --bg-secondary: #f8f9fa;   /* Cinza claro */
}
```

### Componentes

- **Cards** - `.card`, `.card-header`, `.card-body`
- **Formulários** - `.form-group`, `.form-label`, `.form-control`
- **Botões** - `.btn`, `.btn-primary`, `.btn-secondary`, etc
- **Tabelas** - `.table`, `.table-responsive`
- **Badges** - `.badge-success`, `.badge-warning`, etc
- **Alerts** - `.alert-success`, `.alert-danger`, etc

### Responsivo

O CSS é 100% responsivo usando:
- Grid adaptável: `.grid`, `.grid-2`, `.grid-3`, `.grid-4`
- Media queries para mobile (`@media (max-width: 768px)`)
- Design mobile-first

---

## 🔄 FLUXO DE TRABALHO

### 1. Deploy Automático

Quando você faz **push para o GitHub**, o Cloudflare automaticamente:
1. Detecta mudanças no branch `main`
2. Faz build do projeto
3. Faz deploy em ~2 minutos
4. Atualiza https://aprenderensinando.pages.dev/

### 2. Fazer Mudanças no Código

```powershell
# 1. Editar arquivos
# 2. Commit
cd "PROJETO APRENDER ENSINANDO"
git add .
git commit -m "Descrição da mudança"
git push

# 3. Aguardar 2min e testar no site
```

### 3. Adicionar Nova Funcionalidade

**SEMPRE copie a estrutura de inicialização do Supabase de uma página existente!**

Exemplo (copiar de `index.html`, `dashboard.html`, etc):

```javascript
<script src="https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2"></script>
<script>
  const sb = window.supabase.createClient(
    'https://ukjxekdwumfxilphrrmb.supabase.co',
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...'
  );
  
  // Adicionar funções necessárias
</script>
```

---

## 🐛 PROBLEMAS CONHECIDOS E SOLUÇÕES

### Problema: "Identifier 'supabase' has already been declared"

**Causa:** Usar `const supabase` em vez de `const sb`

**Solução:** SEMPRE use `const sb`

### Problema: "Cannot read properties of undefined (reading 'auth')"

**Causa:** Supabase não foi inicializado corretamente

**Solução:** Verificar se tem o script de inicialização antes do código que usa `sb`

### Problema: Site não atualiza após deploy

**Causa:** Cache do Cloudflare ou do navegador

**Solução:** 
1. Aguardar 2-3 minutos
2. Limpar cache: Ctrl + Shift + R
3. Ou abrir em aba anônima

### Problema: Dados não salvam

**Causa:** RLS (Row Level Security) bloqueando

**Solução:** Verificar se `usuario_id` está sendo enviado nos inserts/updates

---

## 📊 FUNCIONALIDADES DO SISTEMA

### 1. Login / Autenticação (`index.html`)
- Login com email/senha
- Criar nova conta
- Recuperar senha (não implementado ainda)
- Redirecionamento automático se já logado

### 2. Dashboard (`dashboard.html`)
- Estatísticas: total pacientes, atendimentos hoje/mês, receita mensal
- Próximos atendimentos
- Pacientes recentes
- Avisos (pacientes pendentes para agendar)
- Ações rápidas (botões para principais funcionalidades)

### 3. Cadastro de Pacientes (`cadastro.html`)
- **Dados da criança:** nome, nascimento, sexo, escola, série
- **Responsáveis:** pai, mãe, avós, telefone, email, endereço
- **Entrevista inicial:** 4 perguntas importantes
  1. Queixa livre (o que trouxe à clínica)
  2. Quando começou o problema
  3. Como a família se sente
  4. O que a escola disse
- Gera ID automático (ALU-001, ALU-002...)
- Opção de agendar primeira aula ao finalizar

### 4. Lista de Pacientes (`alunos.html`)
- Visualizar todos os pacientes
- Filtros: nome, ID, status (ativo/pendente)
- Modal com detalhes completos do paciente
- Histórico de sessões
- Botões: Agendar aula, Registrar sessão

### 5. Agenda (`agenda.html`)
- Visualizar agendamentos por data
- Criar novo agendamento
- Editar/Excluir agendamentos futuros
- Marcar atendimentos passados como realizados
- Resumo: hoje, semana, mês

### 6. Registro de Sessões (`sessao.html`)
- Selecionar paciente
- Data da sessão
- Atividades realizadas
- Observações sobre o aluno
- Progressão/evolução
- Próximas etapas

### 7. Controle Financeiro (`financeiro.html`)
- Registrar receitas (pagamentos recebidos)
- Registrar despesas (custos da clínica)
- Vincular a paciente (opcional)
- Categorias: Consulta, Avaliação, Material, Aluguel, Outros
- Resumo mensal: receitas, despesas, saldo
- Filtros: tipo, mês, categoria

---

## 🔒 SEGURANÇA

### Dados Protegidos
- ✅ Autenticação obrigatória (exceto página de login)
- ✅ RLS ativado em todas as tabelas
- ✅ Cada usuário vê apenas seus dados
- ✅ Dados sensíveis (senha) criptografados pelo Supabase Auth
- ✅ Headers de segurança HTTP (`_headers`)

### Conformidade LGPD
- Dados pessoais armazenados de forma segura
- Acesso restrito por autenticação
- Possibilidade de exclusão de dados

---

## 📞 SUPORTE E MANUTENÇÃO

### Como Adicionar Novo Campo em Pacientes

1. **No Supabase:**
```sql
ALTER TABLE pacientes ADD COLUMN novo_campo TEXT;
```

2. **No HTML (cadastro.html):**
```html
<div class="form-group">
  <label for="novoCampo" class="form-label">Novo Campo</label>
  <input type="text" id="novoCampo" class="form-control">
</div>
```

3. **No JavaScript:**
```javascript
const pacienteData = {
  // ... outros campos
  novo_campo: document.getElementById('novoCampo').value.trim()
};
```

### Como Adicionar Nova Página

1. Copiar estrutura de `dashboard.html`
2. Trocar conteúdo do `<body>`
3. Manter scripts de inicialização do Supabase
4. Adicionar link no menu de todas as páginas

### Como Fazer Backup

**Banco de Dados:**
- Supabase → Database → Backups (plano pago)
- Ou exportar manualmente via SQL

**Código:**
- Já versionado no GitHub
- Fazer clone: `git clone https://github.com/RenatoCarbone/aprenderensinando.git`

---

## 📈 PRÓXIMAS MELHORIAS (TODO)

- [ ] Gerar relatórios em PDF
- [ ] Envio de emails/WhatsApp automático
- [ ] Dashboard com gráficos
- [ ] Exportar dados para Excel
- [ ] Sistema de notificações
- [ ] Upload de arquivos (fotos, documentos)
- [ ] Recuperação de senha funcional
- [ ] Modo escuro
- [ ] Multi-idioma

---

## 👨‍💻 COMANDOS ÚTEIS

```powershell
# Navegar até o projeto
cd "PROJETO APRENDER ENSINANDO"

# Ver status do Git
git status

# Fazer commit e push
git add .
git commit -m "Mensagem"
git push

# Ver histórico de commits
git log --oneline -10

# Criar novo arquivo
New-Item -Path "public/nova-pagina.html" -ItemType File

# Abrir arquivo
code "public/index.html"
```

---

## 🎯 CONCLUSÃO

Este é um sistema **completo e funcional** para gestão de clínica psicopedagógica.

**Principais características:**
- ✅ Simples de usar
- ✅ Responsivo (funciona em celular/tablet)
- ✅ Seguro (autenticação + RLS)
- ✅ Rápido (Cloudflare Pages)
- ✅ Gratuito para hospedar
- ✅ Fácil de manter

**Stack moderna mas simples:**
- Sem frameworks pesados
- JavaScript vanilla (fácil de entender)
- Supabase (backend pronto)
- Deploy automático

---

**Desenvolvido com ❤️ por Renato Carbone para Priscila Carbone**

**Data:** Março de 2026

---

## 📝 NOTAS IMPORTANTES PARA O AGENTE IA

Se você é um agente IA lendo este documento, aqui está o que você precisa saber:

1. **Inicialização do Supabase:** SEMPRE use `const sb`, NUNCA `const supabase`
2. **Não há config.js:** O arquivo foi deletado, tudo é inline
3. **Autenticação:** Todas as páginas (exceto index.html) requerem autenticação
4. **Deploy:** Automático via GitHub → Cloudflare (aguardar 2min)
5. **Credenciais de teste:** teste@teste.com / 123456
6. **Estrutura do DB:** 5 tabelas (usuarios, pacientes, agendamentos, sessoes, financeiro)
7. **RLS ativado:** Cada usuário vê apenas seus dados

**Problemas comuns já resolvidos:**
- ✅ "supabase already declared" → Usar `sb`
- ✅ Cache não atualiza → Aguardar 2min + Ctrl+Shift+R
- ✅ Login não funciona → Verificar se usuário existe no Supabase Auth

**Este projeto está COMPLETO e FUNCIONANDO!** 🎉
