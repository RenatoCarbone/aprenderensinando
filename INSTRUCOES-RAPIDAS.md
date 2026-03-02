# ⚡ Instruções Rápidas - Começar Agora!

## 🎯 O QUE FAZER AGORA

Você tem 3 coisas para fazer:

### 1. CONFIGURAR SUPABASE (5 minutos)
- Acesse: https://supabase.com
- Crie novo projeto
- Execute os 3 arquivos SQL da pasta `config/`
- Copie URL e chave do projeto

### 2. CONFIGURAR CÓDIGO (2 minutos)
Edite o arquivo: `public/js/config.js`

Mude estas linhas:
```javascript
url: 'YOUR_SUPABASE_URL',
anonKey: 'YOUR_SUPABASE_ANON_KEY'
```

Para suas credenciais do Supabase.

### 3. SUBIR PARA GITHUB E CLOUDFLARE (5 minutos)

**No PowerShell:**
```powershell
cd "PROJETO APRENDER ENSINANDO"
git init
git add .
git commit -m "Sistema Aprender Ensinando"
git remote add origin https://github.com/RenatoCarbone/aprenderensinando.git
git branch -M main
git push -u origin main
```

**No Cloudflare:**
- Acesse: https://dash.cloudflare.com
- Workers & Pages → Create → Pages
- Conecte com GitHub
- Selecione repositório: aprenderensinando
- Build output: `public`
- Adicione variáveis de ambiente (URL e KEY do Supabase)
- Deploy!

---

## ✅ PRONTO!

Acesse seu site e crie sua conta!

**Dúvidas?** Leia o `GUIA-CONFIGURACAO.md` completo.

**Como usar?** Leia o `GUIA-USO-SISTEMA.md`.
