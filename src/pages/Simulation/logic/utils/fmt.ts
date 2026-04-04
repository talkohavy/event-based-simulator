export function fmt(n: number, decimals = 4): string {
  return Number.isFinite(n) ? n.toFixed(decimals) : '∞';
}
