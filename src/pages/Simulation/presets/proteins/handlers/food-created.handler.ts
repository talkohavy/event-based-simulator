import { assignJob } from '../assignJob';
import type { ProteinsConfig } from '../types';
import type { SimulationContext } from '@src/lib/simulation';

/**
 * A protein has finished producing one food unit.
 *
 * 1. Food count increases by 1.
 * 2. If any protein is sleeping (waiting for food), wake one up and give it a job.
 * 3. The protein that just finished also gets a new job.
 */
export function foodCreatedHandler(config: ProteinsConfig) {
  return ({ state, schedule, rng, distributions, stats, clock }: SimulationContext) => {
    state.food++;

    if (state.sleeping > 0) {
      state.sleeping--;
      assignJob(state, schedule, rng, distributions, config);
    }

    assignJob(state, schedule, rng, distributions, config);

    stats.recordTimeSeries('proteins', clock, state.proteins);
    stats.recordTimeSeries('food', clock, state.food);
    stats.recordTimeSeries('alpha', clock, state.currentAlpha);
  };
}
