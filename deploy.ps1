# ============================================
# SCRIPT DE DEPLOY - APRENDER ENSINANDO
# ============================================

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "   DEPLOY - APRENDER ENSINANDO" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# Verificar se esta na pasta correta
if (-not (Test-Path "public")) {
    Write-Host "ERRO: Execute este script na pasta raiz do projeto!" -ForegroundColor Red
    pause
    exit
}

# Verificar se git esta instalado
try {
    git --version | Out-Null
    Write-Host "Git instalado" -ForegroundColor Green
} catch {
    Write-Host "ERRO: Git nao encontrado!" -ForegroundColor Red
    Write-Host "Instale em: https://git-scm.com/download/win" -ForegroundColor Yellow
    pause
    exit
}

Write-Host ""
Write-Host "Verificando status do repositorio..." -ForegroundColor Yellow

# Status do git
git status

Write-Host ""
$continuar = Read-Host "Deseja continuar com o deploy? (s/n)"

if ($continuar -ne "s" -and $continuar -ne "S") {
    Write-Host "Deploy cancelado!" -ForegroundColor Yellow
    pause
    exit
}

Write-Host ""
Write-Host "Adicionando arquivos ao git..." -ForegroundColor Yellow
git add .

Write-Host ""
$mensagem = Read-Host "Digite a mensagem do commit (ou ENTER para usar padrao)"

if ([string]::IsNullOrWhiteSpace($mensagem)) {
    $mensagem = "Atualizacao automatica - $(Get-Date -Format 'dd/MM/yyyy HH:mm')"
}

Write-Host ""
Write-Host "Fazendo commit..." -ForegroundColor Yellow
git commit -m "$mensagem"

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "Nenhuma alteracao para commitar!" -ForegroundColor Yellow
    Write-Host "Tentando fazer push mesmo assim..." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Enviando para GitHub..." -ForegroundColor Yellow
git push

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "==========================================" -ForegroundColor Green
    Write-Host "   DEPLOY CONCLUIDO COM SUCESSO!" -ForegroundColor Green
    Write-Host "==========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Codigo enviado para o GitHub!" -ForegroundColor Green
    Write-Host ""
    Write-Host "PROXIMOS PASSOS:" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Se ainda nao configurou hospedagem:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "OPCAO 1 - GitHub Pages (Gratis):" -ForegroundColor Cyan
    Write-Host "  1. Va em: https://github.com/SEU-USUARIO/SEU-REPO/settings/pages" -ForegroundColor Gray
    Write-Host "  2. Em 'Source', selecione 'main' e pasta '/public'" -ForegroundColor Gray
    Write-Host "  3. Clique em 'Save'" -ForegroundColor Gray
    Write-Host "  4. Aguarde alguns minutos" -ForegroundColor Gray
    Write-Host "  5. Seu site estara em: https://SEU-USUARIO.github.io/SEU-REPO" -ForegroundColor Gray
    Write-Host ""
    Write-Host "OPCAO 2 - Cloudflare Pages (Gratis - mesma do Quiz):" -ForegroundColor Cyan
    Write-Host "  1. Va em: https://dash.cloudflare.com" -ForegroundColor Gray
    Write-Host "  2. Pages > Create a project" -ForegroundColor Gray
    Write-Host "  3. Connect to Git > Selecione seu repositorio" -ForegroundColor Gray
    Write-Host "  4. Build settings:" -ForegroundColor Gray
    Write-Host "     - Build command: (deixe vazio)" -ForegroundColor Gray
    Write-Host "     - Build output: /public" -ForegroundColor Gray
    Write-Host "  5. Save and Deploy" -ForegroundColor Gray
    Write-Host ""
    Write-Host "OPCAO 3 - Vercel (Gratis):" -ForegroundColor Cyan
    Write-Host "  1. Va em: https://vercel.com" -ForegroundColor Gray
    Write-Host "  2. Import Project > GitHub" -ForegroundColor Gray
    Write-Host "  3. Selecione seu repositorio" -ForegroundColor Gray
    Write-Host "  4. Root Directory: public" -ForegroundColor Gray
    Write-Host "  5. Deploy" -ForegroundColor Gray
    Write-Host ""
} else {
    Write-Host ""
    Write-Host "ERRO ao enviar para GitHub!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Possiveis causas:" -ForegroundColor Yellow
    Write-Host "1. Repositorio remoto nao configurado" -ForegroundColor Gray
    Write-Host "2. Sem permissao (precisa fazer login no git)" -ForegroundColor Gray
    Write-Host "3. Problemas de conexao" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Para configurar repositorio remoto:" -ForegroundColor Cyan
    Write-Host "  git remote add origin https://github.com/SEU-USUARIO/SEU-REPO.git" -ForegroundColor Gray
    Write-Host "  git branch -M main" -ForegroundColor Gray
    Write-Host "  git push -u origin main" -ForegroundColor Gray
    Write-Host ""
}

pause
