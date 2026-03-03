# 🎓 Aprender Ensinando - Sistema de Gestão Psicopedagógica

Sistema web completo para gestão de clínica psicopedagógica, desenvolvido para auxiliar profissionais no gerenciamento de pacientes, agendamentos, sessões e controle financeiro.

## 📋 Funcionalidades Principais

### 🏠 **Dashboard**
- Visão geral com estatísticas de atendimentos
- Cards com total de alunos, aulas do mês e próximas aulas
- Ações rápidas (Novo Cadastro, Nova Aula, Agendar, Ver Alunos, Biblioteca)
- Lista de alunos recentes com botão direto para agendar aula
- Navegação rápida para todas as áreas do sistema

### 👥 **Gestão de Alunos**
- **Cadastro completo** com foto, dados pessoais e entrevista inicial
- **Lista de alunos** com busca e filtros (Ativo/Inativo)
- **Edição completa** incluindo dados dos responsáveis e perguntas da entrevista
- **Configuração de pagamento** individual por aluno (valor, dia vencimento, forma)
- **Botão de contato** direto via WhatsApp com o responsável
- **Histórico** de aulas e evolução do aluno

### 📅 **Agendamento de Aulas**
- **Agendamento múltiplo** - adicione várias datas e horários de uma vez
- **Validação automática** de conflitos de horário
- **Indicação visual** de horários ocupados (marcados em vermelho)
- **Tipos de agendamento:** Aula, Avaliação Inicial, Reunião
- **Duração configurável:** 30 min, 1h, 1h30, 2h
- Visualização por data com filtros

### 📚 **Registro de Aulas**
- Formulário completo para registrar aulas realizadas
- **Mensagem para responsável** com envio direto por WhatsApp
- Seleção de paciente e duração
- Observações e anotações detalhadas
- Histórico de todas as aulas realizadas

### 💰 **Financeiro Completo**
- **Lançamentos** de receitas e despesas
- **Categorias** personalizáveis
- **Filtros** por tipo, categoria e mês
- **Relatórios:**
  - Lançamentos Futuros (Despesas e Receitas)
  - Histórico 12 meses com saldo positivo/negativo
- **Lançamentos recorrentes** - crie múltiplos lançamentos automaticamente
- **Configuração de cobranças** automáticas por aluno
- **Cobranças pendentes** com visualização destacada
- **Gestão de alunos** com busca e visualização de status de pagamento
- Resumo financeiro com receitas, despesas e saldo do mês

### 📖 **Biblioteca de Documentos**
- Armazenamento de documentos e materiais
- Upload de arquivos
- Categorização e busca

### 🎨 **Interface e Usabilidade**
- **Menu lateral retrátil** - maximize o espaço da tela
- **Tooltips** nos ícones do menu minimizado
- **Design responsivo** e moderno
- **Navegação intuitiva** com breadcrumbs
- **Botão "Voltar ao Dashboard"** em todas as páginas
- **Temas** com cores profissionais e agradáveis
- **Ícones** visuais para facilitar identificação

## ✨ Funcionalidades Avançadas

- ✅ **Autenticação segura** via Supabase Auth
- ✅ **Validação de dados** em tempo real
- ✅ **Prevenção de conflitos** em agendamentos
- ✅ **Comunicação via WhatsApp** integrada
- ✅ **Gestão financeira** com lançamentos futuros e recorrentes
- ✅ **Relatórios automáticos** de 12 meses
- ✅ **Upload de fotos** para perfil dos alunos
- ✅ **Row Level Security** (RLS) no banco de dados
- ✅ **PWA Ready** - pode ser instalado como app

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
