# Instruções: Limitar Gestão de Alunos a 15 linhas

## ✅ JÁ IMPLEMENTADO:
- Gestão de Aulas e Pagamentos: limitado a 15 linhas + botão "Ver Todas"

## ⚠️ FALTA FAZER MANUALMENTE:

Na função `renderizarTabelaAlunos` (linha 1348), substituir:

```javascript
alunos.forEach(aluno => {
```

Por:

```javascript
// Limitar a 15 linhas
const alunosExibir = alunos.slice(0, 15);
const temMais = alunos.length > 15;

alunosExibir.forEach(aluno => {
```

E antes do `container.innerHTML = html;` (linha 1379), adicionar:

```javascript
        html += '</tbody></table>';
        
        // Adicionar botão "Ver Todas" se tiver mais de 15 linhas
        if (temMais) {
          html += `
            <div style="text-align: center; margin-top: 1.5rem;">
              <button onclick="window.location.href='/alunos.html'" style="background: linear-gradient(135deg, #8B5CF6 0%, #7C3AED 100%); color: white; border: none; padding: 1rem 2rem; border-radius: 8px; font-weight: 600; cursor: pointer; font-size: 1rem; box-shadow: 0 4px 12px rgba(139, 92, 246, 0.3);">
                📋 Ver Todos (${alunos.length} alunos)
              </button>
            </div>
          `;
        }
        
        container.innerHTML = html;
```

## Deploy:
Depois de fazer essas alterações, rode:
```powershell
cd "PROJETO APRENDER ENSINANDO"
git add .
git commit -m "feat: limitar seções colapsáveis a 15 linhas com botão Ver Todas"
git push
```
