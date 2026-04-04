export function downsample<T>(data: T[], maxPoints: number): T[] {
  const result: T[] = [data[0]!];
  const step = (data.length - 1) / (maxPoints - 1);

  for (let i = 1; i < maxPoints - 1; i++) {
    result.push(data[Math.round(i * step)]!);
  }

  result.push(data[data.length - 1]!);

  return result;
}
