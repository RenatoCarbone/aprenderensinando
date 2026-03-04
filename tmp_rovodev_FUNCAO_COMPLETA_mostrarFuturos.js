// COPIE ESTA FUNÇÃO COMPLETA E SUBSTITUA A FUNÇÃO mostrarFuturos (linha 1719-1780)
// NO ARQUIVO public/financeiro.html

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
              tipo: 'receita'
            });
          }
        }
      }
    }

    const container = document.getElementById('conteudoRelatorio');
    
    if (!lancamentos || lancamentos.length === 0) {
      container.innerHTML = `
        <div style="text-align: center; padding: 3rem; color: var(--text-tertiary);">
          <div style="font-size: 3rem; margin-bottom: 1rem;">📭</div>
          <h3>Nenhum lançamento futuro encontrado</h3>
          <p>Não há ${tipo === 'receita' ? 'receitas' : 'despesas'} previstas no momento.</p>
        </div>
      `;
      return;
    }

    const total = lancamentos.reduce((sum, item) => sum + parseFloat(item.valor), 0);
    
    let html = `
      <div style="display: flex; flex-direction: column; gap: 1rem;">
        ${lancamentos.map(item => `
          <div class="futuro-card">
            <div class="futuro-icon">${tipo === 'receita' ? '💵' : '💸'}</div>
            <div class="futuro-info">
              <h3>${item.descricao}</h3>
              <p>${item.categoria} - ${formatDate(item.data_prevista)}</p>
            </div>
            <div class="futuro-valor ${tipo === 'receita' ? 'success' : 'danger'}">
              R$ ${parseFloat(item.valor).toFixed(2)}
            </div>
            ${!item.id.startsWith('aula-') ? `
              <button onclick="marcarComoConcluido('${item.id}', '${tipo}')" class="btn btn-success btn-sm">
                ✅ Concluir
              </button>
            ` : ''}
          </div>
        `).join('')}
      </div>
      
      <div style="margin-top: 2rem; padding: 1.5rem; background: var(--bg-secondary); border-radius: var(--radius); text-align: center;">
        <h3 style="margin: 0;">Total ${tipo === 'receita' ? 'a Receber' : 'a Pagar'}</h3>
        <div style="font-size: 2rem; font-weight: 700; color: ${tipo === 'receita' ? 'var(--success)' : 'var(--danger)'}; margin-top: 0.5rem;">
          R$ ${total.toFixed(2)}
        </div>
      </div>
    `;
    
    container.innerHTML = html;

  } catch (error) {
    console.error('Erro ao carregar futuros:', error);
    showAlert('Erro ao carregar dados', 'danger');
  } finally {
    showLoading(false);
  }
}
