# 📊 STATUS ATUAL DO PROJETO - APRENDER ENSINANDO

**Última atualização:** 02/03/2026 - 18:30h

---

## 🌐 INFORMAÇÕES DE DEPLOY

- **URL do Site:** https://aprenderensinando.pages.dev
- **Plataforma:** Cloudflare Pages
- **Repositório GitHub:** https://github.com/RenatoCarbone/aprenderensinando
- **Branch:** main
- **Deploy:** Automático (push no GitHub → deploy em 1-2min)

---

## ✅ FUNCIONALIDADES IMPLEMENTADAS

### **Módulo de Pacientes**
- ✅ Cadastro completo de pacientes/alunos
- ✅ 13 perguntas de entrevista inicial
- ✅ Campo "Telefone Secundário" (adicionado 02/03/2026)
- ✅ Checkbox "Autorização de uso de imagem" (adicionado 02/03/2026)
- ✅ Campos de mãe e telefone **não obrigatórios** (alterado 02/03/2026)
- ✅ Lista de todos os pacientes
- ✅ Edição de pacientes

### **Módulo de Agendamentos**
- ✅ Criar agendamentos por data/horário
- ✅ Visualizar agenda completa
- ✅ Filtro por data
- ✅ Vincular paciente ao agendamento
- ✅ Editar/excluir agendamentos

### **Módulo de Aulas** (NOVO - 02/03/2026)
- ✅ Botão "📚 Registrar Aula" no dashboard
- ✅ Lista automática de agendamentos do dia atual
- ✅ Sistema de presença individual (checkbox por aluno)
- ✅ Campo "O que foi aplicado na aula" (obrigatório)
- ✅ Campo "Observações gerais do dia" (opcional)
- ✅ Ao marcar presença, abre:
  - Campo "Observações individuais" do aluno
  - Campo "Mensagem para o responsável"
- ✅ Salva tudo em 2 tabelas: `aulas` + `aulas_presenca`
- ✅ **CORREÇÃO:** Data usa horário local (Brasil) ao invés de UTC

### **Dashboard**
- ✅ Cards com estatísticas
- ✅ Botões de acesso rápido
- ✅ Bem-vindo personalizado

### **Autenticação**
- ✅ Login/Logout com Supabase Auth
- ✅ RLS (Row Level Security) - cada usuário vê só seus dados

---

## 🗄️ BANCO DE DADOS (SUPABASE)

### **Tabelas Existentes:**

#### 1. **pacientes**
Campos principais:
- Dados da criança
- Responsáveis (pai, mãe, avó, outro)
- `telefone` (texto, não obrigatório)
- `telefone2` (texto) - **NOVO**
- `autorizacao_imagem` (boolean) - **NOVO**
- 13 campos de entrevista inicial

#### 2. **agendamentos**
- `paciente_id` (FK)
- `profissional_id` (FK)
- `data` (date)
- `horario` (time)
- `observacoes`

#### 3. **aulas** - **NOVA (02/03/2026)**
- `id` (UUID, PK)
- `data` (DATE)
- `horario` (TIME)
- `conteudo_aplicado` (TEXT) - O que foi aplicado
- `observacoes_gerais` (TEXT) - Observações do dia
- `profissional_id` (UUID, FK)

#### 4. **aulas_presenca** - **NOVA (02/03/2026)**
- `id` (UUID, PK)
- `aula_id` (UUID, FK → aulas)
- `paciente_id` (UUID, FK → pacientes)
- `presente` (BOOLEAN)
- `observacoes_individuais` (TEXT)
- `mensagem_responsavel` (TEXT)

---

## 📝 ARQUIVOS SQL IMPORTANTES

Execute na ordem no Supabase SQL Editor:

1. ✅ **Já executado:** Setup inicial
2. ✅ **05-adicionar-campos-telefone2-autorizacao-imagem.sql** (executado 02/03)
3. ✅ **06-criar-tabelas-aulas.sql** (executado 02/03)

---

## 🚀 COMO FAZER DEPLOY

### **Método 1: Automático (Recomendado)**

No Git Bash, na pasta do projeto:

```bash
git add .
git commit -m "Descrição da alteração"
git push origin main
```

Aguarde 1-2 minutos e acesse: https://aprenderensinando.pages.dev

---

### **Método 2: Script PowerShell**

```powershell
.\deploy.ps1
```

Segue as instruções do script.

---

## 🐛 CORREÇÕES RECENTES

### **02/03/2026 - 18:30h - Bug de Fuso Horário**

**Problema:** 
- Página "Registrar Aula" mostrava 0 agendamentos
- Tinha 3 agendamentos para 02/03/2026 às 20h
- Horário atual: 18h (Brasil)

**Causa:**
- JavaScript usava `toISOString()` que retorna UTC
- UTC estava 3h adiantado = dia 03/03 ao invés de 02/03

**Solução:**
```javascript
// ANTES (errado)
const dataSQL = hoje.toISOString().split('T')[0]; // UTC

// DEPOIS (correto)
const ano = hoje.getFullYear();
const mes = String(hoje.getMonth() + 1).padStart(2, '0');
const dia = String(hoje.getDate()).padStart(2, '0');
const dataSQL = `${ano}-${mes}-${dia}`; // Horário local
```

**Arquivo alterado:** `public/registrar-aula.html`

---

## 🎯 PÁGINAS DISPONÍVEIS

| Página | URL | Função |
|--------|-----|--------|
| Login | `/` ou `/index.html` | Autenticação |
| Dashboard | `/dashboard.html` | Tela principal |
| Cadastrar Paciente | `/cadastro.html` | Novo paciente |
| Lista de Pacientes | `/alunos.html` | Ver todos |
| Agendamentos | `/agenda.html` | Ver/criar agendamentos |
| **Registrar Aula** | `/registrar-aula.html` | **NOVO - Registro de aula** |
| Financeiro | `/financeiro.html` | Receitas/despesas |

---

## 📋 TODO / PRÓXIMAS FUNCIONALIDADES

### **Curto Prazo:**
- [ ] Testar sistema de registro de aulas em produção
- [ ] Ver histórico de aulas registradas
- [ ] Relatório de presença por período
- [ ] Exportar lista de presença (PDF/Excel)

### **Médio Prazo:**
- [ ] Envio automático de mensagens para responsáveis (via WhatsApp/Email)
- [ ] Dashboard com gráficos de presença
- [ ] Relatório de frequência individual
- [ ] Calendário visual de aulas

### **Longo Prazo:**
- [ ] Sistema de notificações
- [ ] App mobile (PWA)
- [ ] Integração com WhatsApp Business API
- [ ] Módulo de relatórios avançados

---

## 🔧 TROUBLESHOOTING

### **Deploy não atualiza?**

1. Verifica se fez push:
   ```bash
   git status
   git log --oneline -n 3
   ```

2. Verifica Cloudflare:
   - https://dash.cloudflare.com
   - Workers & Pages > aprenderensinando
   - Veja último deployment

3. Limpa cache do navegador:
   - Ctrl+Shift+R (recarregar forçado)
   - Ou aba anônima

### **Agendamentos não aparecem em "Registrar Aula"?**

1. Verifica se está logado com o usuário correto
2. Verifica a data dos agendamentos (deve ser hoje)
3. Abre console (F12) e veja se tem erro
4. Veja no console o log: "Data SQL buscando: YYYY-MM-DD"

### **Erro ao salvar dados?**

1. Verifica se as tabelas novas foram criadas no Supabase
2. Executa os SQLs da pasta `config/`
3. Verifica RLS (Row Level Security)

---

## 📞 SUPORTE

- **Desenvolvedor:** Rovo Dev (IA)
- **Repositório:** https://github.com/RenatoCarbone/aprenderensinando
- **Issues:** Criar issue no GitHub

---

## 📊 ESTATÍSTICAS DO PROJETO

- **Data de início:** Janeiro 2026
- **Última atualização:** 02/03/2026
- **Total de páginas:** 8
- **Total de tabelas:** 4
- **Plataforma:** Supabase + Cloudflare Pages
- **Tecnologias:** HTML, CSS, JavaScript, Supabase

---

**Projeto funcionando e no ar! 🎉**

https://aprenderensinando.pages.dev
