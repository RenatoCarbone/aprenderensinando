// Utilidades comuns - Aprender Ensinando

/**
 * Formata horário corrigindo fuso horário UTC para local (Brasília)
 * @param {string} dataHoraISO - String ISO do timestamp (ex: "2026-03-02T20:00:00Z")
 * @returns {string} - Horário formatado (ex: "20:00")
 */
export function formatarHorario(dataHoraISO) {
  if (!dataHoraISO) return '-';
  
  const data = new Date(dataHoraISO);
  return data.toLocaleTimeString('pt-BR', {
    hour: '2-digit',
    minute: '2-digit',
    timeZone: 'America/Sao_Paulo'
  });
}

/**
 * Formata data corrigindo fuso horário
 * @param {string} dataHoraISO - String ISO do timestamp
 * @returns {string} - Data formatada (ex: "02/03/2026")
 */
export function formatarData(dataHoraISO) {
  if (!dataHoraISO) return '-';
  
  const data = new Date(dataHoraISO);
  return data.toLocaleDateString('pt-BR', {
    timeZone: 'America/Sao_Paulo'
  });
}

/**
 * Formata data completa (com dia da semana)
 * @param {string} dataHoraISO - String ISO do timestamp
 * @returns {string} - Data formatada (ex: "segunda-feira, 02 de março de 2026")
 */
export function formatarDataCompleta(dataHoraISO) {
  if (!dataHoraISO) return '-';
  
  const data = new Date(dataHoraISO);
  return data.toLocaleDateString('pt-BR', {
    weekday: 'long',
    day: '2-digit',
    month: 'long',
    year: 'numeric',
    timeZone: 'America/Sao_Paulo'
  });
}

/**
 * Cria timestamp em horário local (Brasília) ao invés de UTC
 * Usa ao criar agendamentos
 * @param {string} data - Data no formato YYYY-MM-DD
 * @param {string} hora - Hora no formato HH:mm
 * @returns {string} - ISO string corrigido
 */
export function criarTimestampLocal(data, hora) {
  const dataHoraLocal = new Date(`${data}T${hora}:00`);
  const offset = dataHoraLocal.getTimezoneOffset() * 60000;
  const dataHoraCorrigida = new Date(dataHoraLocal.getTime() - offset);
  return dataHoraCorrigida.toISOString();
}
