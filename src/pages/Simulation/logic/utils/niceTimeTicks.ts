export function niceTimeTicks(min: number, max: number, count: number): number[] {
  const range = max - min;
  if (range <= 0) return [min];
  const rawStep = range / count;
  const magnitude = 10 ** Math.floor(Math.log10(rawStep));
  const normalized = rawStep / magnitude;
  let niceStep: number;
  if (normalized <= 1.5) niceStep = 1;
  else if (normalized <= 3.5) niceStep = 2;
  else if (normalized <= 7.5) niceStep = 5;
  else niceStep = 10;
  niceStep *= magnitude;

  const ticks: number[] = [];
  const start = Math.ceil(min / niceStep) * niceStep;
  for (let t = start; t <= max; t += niceStep) {
    ticks.push(Math.round(t * 1e10) / 1e10);
  }
  return ticks;
}
