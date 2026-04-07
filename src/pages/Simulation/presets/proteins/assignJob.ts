import { ProteinEventTypes } from './constants';
import type { ProteinsConfig } from './types';
import type { DistributionFunctions } from '@src/lib/simulation';

/**
 * Assigns the next task to a free protein.
 *
 * With probability `alpha` the protein tries to duplicate (consuming 1 food).
 * If no food is available, it joins the sleeping queue instead.
 * Otherwise it starts producing food.
 */
export function assignJob(
  state: Record<string, any>,
  schedule: (delay: number, type: string) => number,
  rng: () => number,
  distributions: DistributionFunctions,
  config: ProteinsConfig,
): void {
  const u = rng();

  if (u <= config.alpha) {
    if (state.food >= 1) {
      state.food--;
      schedule(distributions.exponential(1 / config.meanDuplicateTime), ProteinEventTypes.ProteinDuplicated);
    } else {
      state.sleeping++;
    }
  } else {
    schedule(distributions.exponential(1 / config.meanFoodTime), ProteinEventTypes.FoodCreated);
  }
}
