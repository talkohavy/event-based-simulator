import { assignJob } from '../assignJob';
import type { ProteinsConfig } from '../types';
import type { SimulationContext } from '@src/lib/simulation';

/**
 * A protein has finished duplicating — a new protein is born.
 *
 * 1. Protein count increases by 1.
 * 2. The newly born protein gets a job.
 * 3. The parent protein that did the duplicating also gets a new job.
 */
export function proteinDuplicatedHandler(config: ProteinsConfig) {
  return ({ state, schedule, rng, distributions, stats, clock }: SimulationContext) => {
    state.proteins++;

    assignJob(state, schedule, rng, distributions, config);
    assignJob(state, schedule, rng, distributions, config);

    stats.recordTimeSeries('proteins', clock, state.proteins);
    stats.recordTimeSeries('food', clock, state.food);
  };
}
