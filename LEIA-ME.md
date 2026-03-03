# 📚 Projeto Aprender Ensinando

Sistema de gestão para profissionais de pedagogia/psicopedagogia gerenciar alunos, aulas e documentos.

---

## 🎯 **STATUS ATUAL DO PROJETO**

### ✅ **Funcionalidades Implementadas:**

#### 1. **Sistema de Login e Autenticação**
- Login com email e senha
- Autenticação via Supabase
- Proteção de rotas

#### 2. **Dashboard Principal** 
- ✅ Estatísticas (Total de Alunos, Aulas Hoje, Aulas no Mês)
- ✅ Ações Rápidas (Novo Cadastro, Nova Aula, Agendar, Ver Alunos)
- ✅ **NOVO: Calendário/Agenda Interativo com 3 vistas:**
  - **📅 Vista DIA:** Lista de aulas do dia com horários
  - **📊 Vista SEMANA:** Grid com total de aulas por dia da semana
  - **📆 Vista MÊS:** Calendário completo com badges de quantidade
- ✅ Alunos Recentes

#### 3. **Gestão de Alunos**
- Cadastro completo de alunos (dados pessoais, responsáveis, entrevista)
- Lista de alunos com busca
- Edição de alunos com upload de foto
- Histórico de aulas por aluno
- **Resumo de Aulas** (versão para impressão)

#### 4. **Sistema de Agendamentos**
- Agendar aulas com data/hora/duração
- **3 tipos de agendamento:**
  - 📚 **Aula** (padrão) - Requer aluno
  - 💬 **Avaliação Inicial** - Sem aluno (primeiro contato)
  - 👥 **Reunião** - Para entregas de laudo, feedback, etc.
- Filtros por data e paciente
- Visualização em lista

#### 5. **Registro de Aulas**
- Registrar conteúdo aplicado
- Observações gerais
- Mensagem para responsável
- Lista de aulas agendadas do dia
- Botão "Iniciar Aula" para aulas agendadas
- **Botão "Novo Cadastro"** para Avaliações Iniciais

#### 6. **Sistema de Documentos** 
- **📚 Biblioteca de Documentos:** Upload de modelos/templates gerais
- **📁 Documentos por Aluno:** 
  - Upload de arquivos específicos
  - Renomear documentos
  - Download individual
  - **Baixar todos** (um por vez com delay)
  - Suporte: PDF, Word, Excel, PowerPoint, Imagens
- Storage via Supabase

#### 7. **Financeiro**
- Controle de receitas
- Filtros por mês e categoria
- Estatísticas financeiras

#### 8. **Design Moderno**
- Layout responsivo com sidebar fixa
- Cards modernos com gradientes
- Botões grandes e destacados
- Cores da identidade visual (#4FBECD)
- Emojis para melhor UX

---

## 🚧 **PRÓXIMA FUNCIONALIDADE A IMPLEMENTAR**

### **Validação de Conflitos de Horários + Grade Visual**

**Problema:** 
Atualmente é possível agendar 2 alunos no mesmo horário, causando conflito.

**Solução Planejada:**

#### **1. Validação de Conflitos:**
- Ao agendar, verificar se há sobreposição de horários
- Considerar a duração da aula (ex: aula de 60min às 14:00 ocupa até 15:00)
- Bloquear agendamento se houver conflito

#### **2. Grade Visual de Horários (PRIORIDADE):**

**Fluxo:**
1. Usuário seleciona a **data** no campo de agendamento
2. Sistema carrega todos os agendamentos daquele dia
3. Exibe **grade de horários** (08:00 às 20:00) de forma visual:
   - 🟢 **Verde** = Horário LIVRE (clicável)
   - 🔴 **Vermelho** = Horário OCUPADO (mostra quem está agendado + duração)

**Exemplo Visual:**
```
📅 Horários de 05/03/2026:

🟢 08:00 - Livre
🟢 09:00 - Livre  
🔴 10:00 - OCUPADO (João Silva - 60min, até 11:00)
🔴 11:00 - OCUPADO (continuação)
🟢 12:00 - Livre
🔴 14:00 - OCUPADO (Maria Santos - 90min, até 15:30)
🔴 15:00 - OCUPADO (continuação)
🟢 16:00 - Livre
```

**Implementação:**
- Modificar `agenda.html`
- Criar componente de grade de horários
- Validação no frontend (UX) + backend (segurança)
- Ao clicar em horário livre, preenche automaticamente o campo hora

**Benefícios:**
- ✅ Evita conflitos de agendamento
- ✅ Visualização clara da agenda do dia
- ✅ Facilita encontrar horários disponíveis
- ✅ Melhor UX para profissional

---

## 📂 **Estrutura do Projeto**

```
PROJETO APRENDER ENSINANDO/
├── config/                          # Scripts SQL do banco
│   ├── 01-schema.sql               # Estrutura de tabelas
│   ├── 02-rls-policies.sql         # Políticas de segurança
│   ├── 11-criar-tabelas-documentos.sql  # Sistema de documentos
│   └── ...
├── public/                          # Frontend
│   ├── css/
│   │   └── modern-layout.css       # Estilos modernos
│   ├── js/
│   │   ├── sidebar.js              # Menu lateral reutilizável
│   │   └── supabase.js             # Config Supabase
│   ├── dashboard.html              # Dashboard principal ⭐
│   ├── login.html                  # Login
│   ├── cadastro.html               # Cadastro de alunos
│   ├── alunos.html                 # Lista de alunos
│   ├── agenda.html                 # Agendamentos ⚠️ PRÓXIMA ALTERAÇÃO
│   ├── registrar-aula.html         # Registro de aulas
│   ├── historico-aluno.html        # Histórico + Documentos
│   ├── biblioteca.html             # Biblioteca de documentos
│   ├── financeiro.html             # Controle financeiro
│   └── editar-paciente.html        # Edição de aluno
└── prints/                          # Screenshots e logos
```

---

## 🔧 **Configuração do Projeto**

### **Banco de Dados (Supabase):**
1. Executar scripts SQL na ordem (01, 02, 03...)
2. Criar bucket `documentos` no Storage (público)
3. Configurar credenciais em `js/supabase.js`

### **Deploy:**
- GitHub Pages: `https://aprenderensinando.pages.dev`
- Atualização automática via push no repositório

---

## 🎨 **Padrões de Design**

- **Cores Principais:**
  - Primary: `#4FBECD` (Azul claro)
  - Primary Dark: `#3A9EAF`
  - Verde: `#10B981` (Sucesso)
  - Laranja: `#F59E0B` (Avaliação)
  - Roxo: `#8B5CF6` (Reunião)

- **Botões:**
  - Grandes (1rem × 2rem padding)
  - Com emojis separados
  - Gradientes para destaque
  - Efeito hover: translateY(-3px)

- **Cards:**
  - Border radius: `var(--radius-xl)`
  - Box shadow: `var(--shadow-sm)`
  - Hover: `var(--shadow-md)`

---

## 📝 **Como Continuar o Desenvolvimento**

### **Para implementar a validação de horários:**

1. **Abrir arquivo:** `PROJETO APRENDER ENSINANDO/public/agenda.html`

2. **Localizar:** Modal de novo agendamento (linha ~1094)

3. **Adicionar:** 
   - Campo de data com evento `onchange`
   - Função `carregarHorariosDisponiveis(data)`
   - Componente de grade visual de horários
   - Validação ao salvar

4. **Testar:**
   - Criar 2 agendamentos no mesmo horário
   - Verificar se bloqueia
   - Testar grade visual

---

## 🚀 **Comandos Úteis**

### **Deploy:**
```bash
cd "PROJETO APRENDER ENSINANDO"
git add .
git commit -m "Descrição da alteração"
git push origin main
```

### **Testar localmente:**
```bash
# Servidor simples (se necessário)
python -m http.server 8000
# ou
npx http-server public -p 8000
```

---

## 📞 **Suporte**

Para continuar o desenvolvimento, basta solicitar:
- "Implementar validação de horários na agenda"
- "Criar grade visual de horários disponíveis"
- "Adicionar [nova funcionalidade]"

**Última atualização:** 02/03/2026 - Calendário/Agenda interativo implementado ✅
