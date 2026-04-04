import type { StatsSummary } from '../../types';

type ObservationSeries = {
  count: number;
  mean: number;
  m2: number; // Welford's running sum of squared deviations
  min: number;
  max: number;
};

type TimedObservation = { time: number; value: number };

/**
 * Collects two kinds of statistics:
 *
 * 1. **Observation-based** (via `record`) — discrete samples like wait times.
 *    Uses Welford's online algorithm for numerically stable variance.
 *
 * 2. **Time-weighted** (via `recordTimeSeries`) — values that persist over time
 *    like queue length. Supports time-weighted average computation.
 */
export class StatisticsCollector {
  private series = new Map<string, ObservationSeries>();
  private timedSeries = new Map<string, TimedObservation[]>();

  record(name: string, value: number): void {
    let s = this.series.get(name);

    if (!s) {
      s = { count: 0, mean: 0, m2: 0, min: Number.POSITIVE_INFINITY, max: Number.NEGATIVE_INFINITY };
      this.series.set(name, s);
    }

    s.count++;
    const delta = value - s.mean;
    s.mean += delta / s.count;
    const delta2 = value - s.mean;
    s.m2 += delta * delta2;

    if (value < s.min) s.min = value;
    if (value > s.max) s.max = value;
  }

  recordTimeSeries(name: string, time: number, value: number): void {
    let ts = this.timedSeries.get(name);

    if (!ts) {
      ts = [];
      this.timedSeries.set(name, ts);
    }

    ts.push({ time, value });
  }

  getStats(name: string): StatsSummary | null {
    const s = this.series.get(name);

    if (!s || s.count === 0) return null;

    const variance = s.count > 1 ? s.m2 / (s.count - 1) : 0;

    return {
      name,
      count: s.count,
      mean: s.mean,
      variance,
      stddev: Math.sqrt(Math.max(0, variance)),
      min: s.min,
      max: s.max,
    };
  }

  /**
   * Computes the time-weighted average by treating each recorded value as
   * persisting until the next observation (piecewise-constant interpolation).
   * Unrecorded periods before the first observation are implicitly zero.
   */
  getTimeWeightedAverage(name: string, endTime: number): number | null {
    const ts = this.timedSeries.get(name);

    if (!ts || ts.length === 0) return null;

    if (endTime <= 0) return 0;

    let totalWeightedValue = 0;

    for (let i = 0; i < ts.length; i++) {
      const nextTime = i + 1 < ts.length ? ts[i + 1]!.time : endTime;
      totalWeightedValue += ts[i]!.value * (nextTime - ts[i]!.time);
    }

    return totalWeightedValue / endTime;
  }

  getSummary(): Record<string, StatsSummary> {
    const result: Record<string, StatsSummary> = {};

    for (const name of this.series.keys()) {
      const stats = this.getStats(name);
      if (stats) result[name] = stats;
    }

    return result;
  }

  getTimedSeriesData(): Record<string, TimedObservation[]> {
    const result: Record<string, TimedObservation[]> = {};

    for (const [name, data] of this.timedSeries) {
      result[name] = [...data];
    }

    return result;
  }
}
