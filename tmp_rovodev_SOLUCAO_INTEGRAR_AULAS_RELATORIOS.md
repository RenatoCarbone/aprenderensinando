# 🎯 SOLUÇÃO: Integrar Aulas a Receber no Modal Relatórios

## ❌ PROBLEMA ATUAL:
Quando clica em "Relatórios → Lançamentos Futuros - Receitas":
- Mostra: "Nenhum lançamento futuro encontrado" ❌
- **DEVERIA MOSTRAR:** ricardo carbone - 1 aula (R$ 80,00) ✅

## ✅ SOLUÇÃO COMPLETA:

Na função `mostrarFuturos(tipo)` (linha ~1719), fazer o seguinte:

### PASSO 1: Buscar aulas a receber quando tipo === 'receita'

Adicionar APÓS buscar os lançamentos manuais futuros:

```javascript
// Se for receitas, adicionar também as aulas a receber
if (tipo === 'receita') {
  const { data: pacientes } = await sb
    .from('pacientes')
    .select('id, nome, valor_aula, dia_vencimento')
    .eq('usuario_id', user.id)
    .eq('cobranca_ativa', true);

  if (pacientes && pacientes.length > 0) {
    const hoje = new Date();
    const mes = hoje.getMonth();
    const ano = hoje.getFullYear();
    
    for (const paciente of pacientes) {
      const diaVenc = paciente.dia_vencimento;
      const dataInicio = new Date(ano, mes - 1, diaVenc);
      const dataFim = new Date(ano, mes, diaVenc - 1);
      const dataVencimento = new Date(ano, mes, diaVenc);

      // Buscar aulas REALIZADAS (não agendadas!)
      const { data: aulasRealizadas } = await sb
        .from('aulas')
        .select('id')
        .eq('paciente_id', paciente.id)
        .gte('data', dataInicio.toISOString().split('T')[0])
        .lte('data', dataFim.toISOString().split('T')[0]);

      const totalAulas = aulasRealizadas?.length || 0;
      if (totalAulas === 0) continue;

      // Verificar se já foi pago
      const { data: mensalidade } = await sb
        .from('mensalidades')
        .select('status')
        .eq('paciente_id', paciente.id)
        .eq('data_vencimento', dataVencimento.toISOString().split('T')[0])
        .maybeSingle();

      // Só adiciona se NÃO foi pago
      if (!mensalidade || mensalidade.status !== 'pago') {
        const valorTotal = totalAulas * paciente.valor_aula;
        
        // Adicionar à lista de lançamentos
        lancamentos.push({
          id: `aula-${paciente.id}`,
          tipo_origem: 'aula',
          paciente_nome: paciente.nome,
          totalAulas: totalAulas,
          valor: valorTotal,
          data_prevista: dataVencimento.toISOString().split('T')[0],
          categoria: 'Aulas'
        });
      }
    }
  }
}
```

### PASSO 2: Modificar a renderização para mostrar aulas

No HTML que renderiza os cards, adicionar verificação:

```javascript
${lancamentos.map(item => {
  // Se for aula, mostrar formato diferente
  if (item.tipo_origem === 'aula') {
    return `
      <div class="futuro-card">
        <div class="futuro-icon">📚</div>
        <div class="futuro-info">
          <h3>${item.paciente_nome} - ${item.totalAulas} ${item.totalAulas === 1 ? 'aula' : 'aulas'}</h3>
          <p>Vence em ${formatDate(item.data_prevista)}</p>
        </div>
        <div class="futuro-valor success">
          R$ ${parseFloat(item.valor).toFixed(2)}
        </div>
      </div>
    `;
  }
  
  // Senão, mostra lançamento manual normal
  return `
    <div class="futuro-card">
      <div class="futuro-icon">${item.tipo === 'receita' ? '💵' : '💸'}</div>
      <div class="futuro-info">
        <h3>${item.descricao}</h3>
        <p>${item.categoria} - ${formatDate(item.data_prevista)}</p>
      </div>
      <div class="futuro-valor ${item.tipo === 'receita' ? 'success' : 'danger'}">
        R$ ${parseFloat(item.valor).toFixed(2)}
      </div>
      <button onclick="marcarComoConcluido('${item.id}', '${item.tipo}')" class="btn btn-success btn-sm">
        ✅ Concluir
      </button>
    </div>
  `;
}).join('')}
```

## 🎯 RESULTADO ESPERADO:

```
Lançamentos Futuros - Receitas
━━━━━━━━━━━━━━━━━━━━━━━━━━
📚 ricardo carbone - 1 aula
   R$ 80,00 - Vence 10/03/2026

💵 Venda de Material
   R$ 50,00 - 15/03/2026
   [✅ Concluir]
━━━━━━━━━━━━━━━━━━━━━━━━━━
Total: R$ 130,00
```

## 📝 OBSERVAÇÃO:
A lógica já existe PERFEITAMENTE na função `carregarGestaoAulas()` (linhas 1000-1110).
Basicamente é **COPIAR E ADAPTAR** essa lógica para a função `mostrarFuturos(tipo)`.

---

## 🚀 SESSÃO FOI INCRÍVEL!
Transformamos o sistema financeiro completamente! 🔥
Esta é a ÚLTIMA peça do quebra-cabeça!
