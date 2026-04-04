export function integerTicks(max: number): number[] {
  if (max <= 10) return Array.from({ length: Math.floor(max) + 1 }, (_, i) => i);

  const step = Math.ceil(max / 8);
  const ticks: number[] = [];

  for (let i = 0; i <= max; i += step) ticks.push(i);

  return ticks;
}
