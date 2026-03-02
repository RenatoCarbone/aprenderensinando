# 🚀 Guia Completo de Configuração - Aprender Ensinando

Este guia vai te ensinar passo a passo como configurar e colocar o sistema no ar.

## 📋 Pré-requisitos

- Conta no GitHub (https://github.com)
- Conta no Supabase (https://supabase.com)
- Conta no Cloudflare (https://cloudflare.com)
- Git instalado no computador

---

## 1️⃣ CONFIGURAR O SUPABASE (Banco de Dados)

### Passo 1: Criar Projeto no Supabase

1. Acesse https://supabase.com e faça login
2. Clique em **"New Project"**
3. Preencha:
   - **Name:** aprender-ensinando
   - **Database Password:** Crie uma senha forte (guarde ela!)
   - **Region:** South America (São Paulo)
4. Clique em **"Create new project"**
5. Aguarde 2-3 minutos até o projeto estar pronto

### Passo 2: Executar Scripts SQL

1. No painel do Supabase, vá em **"SQL Editor"** (ícone de código no menu lateral)
2. Clique em **"New query"**
3. Copie TODO o conteúdo do arquivo `config/01-schema.sql`
4. Cole no editor e clique em **"Run"**
5. Repita o processo para:
   - `config/02-rls-policies.sql`
   - `config/03-functions.sql`

✅ **Pronto! Banco de dados configurado!**

### Passo 3: Pegar as Credenciais

1. No Supabase, vá em **"Settings"** → **"API"**
2. Copie e guarde:
   - **Project URL** (algo como: https://xxxxx.supabase.co)
   - **anon/public key** (uma chave grande que começa com eyJ...)

---

## 2️⃣ CONFIGURAR O GITHUB

### Passo 1: Inicializar Git Localmente

1. Abra o PowerShell na pasta do projeto
2. Execute os comandos:

```powershell
cd "PROJETO APRENDER ENSINANDO"
git init
git add .
git commit -m "Primeiro commit - Sistema Aprender Ensinando"
```

### Passo 2: Conectar com o GitHub

```powershell
git remote add origin https://github.com/RenatoCarbone/aprenderensinando.git
git branch -M main
git push -u origin main
```

Se pedir usuário e senha:
- **Usuário:** RenatoCarbone
- **Senha:** Use um Personal Access Token (veja abaixo como criar)

#### Como criar Personal Access Token:
1. GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
2. Generate new token (classic)
3. Marque: `repo` (todas as opções)
4. Generate token
5. Copie o token (use como senha)

✅ **Código no GitHub!**

---

## 3️⃣ CONFIGURAR O CLOUDFLARE PAGES

### Passo 1: Criar Conta e Projeto

1. Acesse https://dash.cloudflare.com
2. Faça login ou crie conta gratuita
3. Vá em **"Workers & Pages"** no menu lateral
4. Clique em **"Create application"**
5. Selecione aba **"Pages"**
6. Clique em **"Connect to Git"**

### Passo 2: Conectar GitHub

1. Clique em **"GitHub"**
2. Autorize o Cloudflare a acessar seu GitHub
3. Selecione o repositório: **aprenderensinando**
4. Clique em **"Begin setup"**

### Passo 3: Configurar Build

1. **Project name:** aprender-ensinando
2. **Production branch:** main
3. **Build command:** (deixe VAZIO)
4. **Build output directory:** public

### Passo 4: Adicionar Variáveis de Ambiente

**IMPORTANTE:** Role a página até encontrar **"Environment variables"**

Clique em **"Add variable"** e adicione:

- **Nome:** `SUPABASE_URL`
  - **Valor:** Cole a URL do seu projeto Supabase

- **Nome:** `SUPABASE_ANON_KEY`
  - **Valor:** Cole a chave anon/public do Supabase

### Passo 5: Deploy

1. Clique em **"Save and Deploy"**
2. Aguarde 1-2 minutos
3. Quando aparecer **"Success"**, clique no link do site

✅ **Sistema no ar!**

---

## 4️⃣ CONFIGURAR O ARQUIVO CONFIG.JS

**IMPORTANTE:** Você precisa atualizar o arquivo de configuração com suas credenciais.

1. Abra o arquivo: `public/js/config.js`
2. Substitua as linhas:

```javascript
const SUPABASE_CONFIG = {
  url: 'SUA_URL_AQUI',
  anonKey: 'SUA_CHAVE_AQUI'
};
```

Por:

```javascript
const SUPABASE_CONFIG = {
  url: 'https://xxxxx.supabase.co', // Sua URL do Supabase
  anonKey: 'eyJhbGc...' // Sua chave anon do Supabase
};
```

3. Salve o arquivo
4. Faça commit e push:

```powershell
git add .
git commit -m "Configurar credenciais Supabase"
git push
```

O Cloudflare vai atualizar automaticamente em 1-2 minutos.

---

## 5️⃣ TESTAR O SISTEMA

### Criar Primeira Conta

1. Acesse seu site: `https://aprender-ensinando.pages.dev`
2. Clique em **"Criar conta"**
3. Preencha:
   - E-mail: seu email
   - Senha: mínimo 6 caracteres
   - Nome completo: Seu nome
4. Clique em OK
5. Faça login com o email e senha criados

### Testar Funcionalidades

✅ Cadastrar um paciente teste
✅ Agendar um atendimento
✅ Registrar uma sessão
✅ Criar um lançamento financeiro

---

## 🔧 PROBLEMAS COMUNS

### "Invalid login credentials"
- Verifique se criou a conta primeiro
- Senha deve ter mínimo 6 caracteres

### Dados não aparecem
- Verifique se configurou o `config.js` corretamente
- Verifique se executou os 3 scripts SQL no Supabase

### Site não atualiza após mudanças
- Aguarde 1-2 minutos após o push
- Limpe o cache do navegador (Ctrl + Shift + R)

---

## 📱 PRÓXIMOS PASSOS

### Domínio Personalizado (Opcional)

1. No Cloudflare Pages, vá em **"Custom domains"**
2. Clique em **"Set up a custom domain"**
3. Digite seu domínio (ex: aprenderensinando.com.br)
4. Siga as instruções

### Backup dos Dados

Os dados estão seguros no Supabase, mas você pode:
1. Supabase → Database → Backups (plano pago)
2. Ou exportar manualmente: SQL Editor → Export

---

## 🆘 SUPORTE

Se tiver problemas:
1. Verifique se seguiu todos os passos
2. Confira os logs no Cloudflare Pages
3. Verifique os logs no navegador (F12 → Console)

---

## ✅ CHECKLIST FINAL

- [ ] Projeto criado no Supabase
- [ ] Scripts SQL executados (3 arquivos)
- [ ] Credenciais copiadas (URL + Key)
- [ ] Código enviado para GitHub
- [ ] Projeto criado no Cloudflare Pages
- [ ] Variáveis de ambiente configuradas
- [ ] config.js atualizado com credenciais
- [ ] Site acessível e funcionando
- [ ] Conta criada e login funcionando
- [ ] Funcionalidades testadas

**Parabéns! Seu sistema está no ar! 🎉**
