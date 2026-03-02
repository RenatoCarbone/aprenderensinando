# 🎓 Aprender Ensinando - Sistema de Gestão Psicopedagógica

Sistema web completo para gestão de clínica psicopedagógica, desenvolvido para auxiliar profissionais no gerenciamento de pacientes, agendamentos, sessões e controle financeiro.

## 📋 Funcionalidades

- ✅ **Dashboard** - Visão geral dos atendimentos e estatísticas
- ✅ **Cadastro de Pacientes** - Formulário completo com entrevista inicial
- ✅ **Agenda** - Gerenciamento de agendamentos e horários
- ✅ **Registro de Sessões** - Anotações detalhadas de cada atendimento
- ✅ **Controle Financeiro** - Receitas, despesas e relatórios
- ✅ **Autenticação** - Sistema seguro de login

## 🚀 Tecnologias

- **Frontend:** HTML5, CSS3, JavaScript (Vanilla)
- **Banco de Dados:** Supabase (PostgreSQL)
- **Hospedagem:** Cloudflare Pages
- **Versionamento:** GitHub

## 📦 Configuração

### 1. Supabase

1. Acesse [supabase.com](https://supabase.com)
2. Crie um novo projeto
3. Execute os scripts SQL da pasta `config/` na ordem:
   - `01-schema.sql` - Cria as tabelas
   - `02-rls-policies.sql` - Configura segurança
   - `03-functions.sql` - Funções auxiliares

4. Copie suas credenciais:
   - Project URL
   - anon/public key

### 2. Configuração Local

1. Clone o repositório:
```bash
git clone https://github.com/RenatoCarbone/aprenderensinando.git
cd aprenderensinando
```

2. Configure as variáveis de ambiente:
```bash
cp .env.example .env
```

3. Edite o arquivo `.env` com suas credenciais do Supabase

### 3. Deploy no Cloudflare Pages

1. Acesse [dash.cloudflare.com](https://dash.cloudflare.com)
2. Vá em "Pages" → "Create a project"
3. Conecte seu repositório GitHub
4. Configure:
   - **Build command:** (deixe vazio)
   - **Build output directory:** `public`
5. Adicione as variáveis de ambiente:
   - `SUPABASE_URL`
   - `SUPABASE_ANON_KEY`
6. Clique em "Save and Deploy"

## 📁 Estrutura do Projeto

```
PROJETO APRENDER ENSINANDO/
├── public/              # Arquivos da aplicação
│   ├── index.html      # Login
│   ├── dashboard.html  # Painel principal
│   ├── cadastro.html   # Cadastro + entrevista
│   ├── alunos.html     # Lista de pacientes
│   ├── agenda.html     # Agendamentos
│   ├── sessao.html     # Registro de sessão
│   ├── financeiro.html # Controle financeiro
│   ├── css/           # Estilos
│   └── js/            # Scripts
├── config/             # Scripts SQL
└── README.md          # Documentação
```

## 🔒 Segurança

- Autenticação via Supabase Auth
- Row Level Security (RLS) habilitado
- Dados sensíveis protegidos
- Conformidade com LGPD

## 📝 Licença

Projeto privado - Todos os direitos reservados

## 👨‍💻 Desenvolvido por

Renato Carbone - 2026
