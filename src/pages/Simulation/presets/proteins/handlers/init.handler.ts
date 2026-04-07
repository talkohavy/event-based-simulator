import { assignJob } from '../assignJob';
import type { ProteinsConfig } from '../types';
import type { InitContext } from '@src/lib/simulation';

export function initHandler(config: ProteinsConfig) {
  return ({ state, schedule, rng, distributions }: InitContext) => {
    state.proteins = config.proteinsStart;
    state.food = config.foodStart;
    state.sleeping = 0;

    for (let i = 0; i < config.proteinsStart; i++) {
      assignJob(state, schedule, rng, distributions, config);
    }
  };
}
