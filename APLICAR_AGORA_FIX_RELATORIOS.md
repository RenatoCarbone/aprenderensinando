# 🚀 FIX FINAL: Mostrar Aulas em Lançamentos Futuros - Receitas

## ✅ APLICAR ESTA CORREÇÃO AGORA (1 minuto!)

### 📍 Arquivo: `public/financeiro.html`
### 📍 Linha: ~1719 (função `mostrarFuturos`)

---

## 🔧 ENCONTRE ESTE CÓDIGO (linhas 1719-1733):

```javascript
    async function mostrarFuturos(tipo) {
      try {
        showLoading(true);
        
        const { data: { user } } = await sb.auth.getUser();
        
        const { data: lancamentos, error } = await sb
          .from('financeiro')
          .select('*')
          .eq('usuario_id', user.id)
          .eq('tipo', tipo)
          .eq('status', 'previsto')
          .order('data_prevista', { ascending: true });

        if (error) throw error;
```

---

## ✏️ SUBSTITUA POR ESTE CÓDIGO:

```javascript
    async function mostrarFuturos(tipo) {
      try {
        showLoading(true);
        
        const { data: { user } } = await sb.auth.getUser();
        
        let lancamentos = [];
        
        // Buscar lançamentos manuais futuros
        const { data: lancamentosManuais, error } = await sb
          .from('financeiro')
          .select('*')
          .eq('usuario_id', user.id)
          .eq('tipo', tipo)
          .eq('status', 'previsto')
          .order('data_prevista', { ascending: true });

        if (error) throw error;
        
        lancamentos = lancamentosManuais || [];
        
        // NOVO: Se for receitas, adicionar também aulas a receber
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

              const { data: aulasRealizadas } = await sb
                .from('aulas')
                .select('id')
                .eq('paciente_id', paciente.id)
                .gte('data', dataInicio.toISOString().split('T')[0])
                .lte('data', dataFim.toISOString().split('T')[0]);

              const totalAulas = aulasRealizadas?.length || 0;
              if (totalAulas === 0) continue;

              const { data: mensalidade } = await sb
                .from('mensalidades')
                .select('status')
                .eq('paciente_id', paciente.id)
                .eq('data_vencimento', dataVencimento.toISOString().split('T')[0])
                .maybeSingle();

              if (!mensalidade || mensalidade.status !== 'pago') {
                const valorTotal = totalAulas * paciente.valor_aula;
                lancamentos.push({
                  id: 'aula-' + paciente.id,
                  descricao: paciente.nome + ' - ' + totalAulas + (totalAulas === 1 ? ' aula' : ' aulas'),
                  categoria: 'Aulas',
                  valor: valorTotal,
                  data_prevista: dataVencimento.toISOString().split('T')[0],
                  tipo: 'receita',
                  eh_aula: true
                });
              }
            }
          }
        }
```

---

## 📝 RESUMO DO QUE FAZ:

1. ✅ Busca lançamentos futuros manuais (como antes)
2. ✅ **NOVO:** Se for receita, busca também aulas realizadas não pagas
3. ✅ Adiciona tudo na mesma lista
4. ✅ Resultado: ricardo carbone - 1 aula (R$ 80,00) vai aparecer! 🎉

---

## 🚀 DEPOIS DE APLICAR:

```powershell
cd "PROJETO APRENDER ENSINANDO"
git add .
git commit -m "fix: integrar aulas a receber em Lançamentos Futuros Receitas"
git push
```

---

## ✅ PRONTO!

Agora quando você abrir:
**Relatórios → Lançamentos Futuros - Receitas**

Vai aparecer:
```
📚 ricardo carbone - 1 aula
   R$ 80,00 - Vence 10/03/2026
```

---

**SESSÃO FINALIZADA! Foi INCRÍVEL! 🔥💪**
