import { ProteinEventTypes } from './constants';
import type { ProteinsConfig } from './types';
import type { DistributionFunctions } from '@src/lib/simulation';

/**
 * Resolves the current alpha value.
 *
 * Fixed mode: uses config.alpha directly.
 * Dynamic mode (Hill function):
 *   α = αSS / (1 + (P · k / F) ^ h)
 *
 * When food is 0 in dynamic mode we return 0 (can't duplicate anyway).
 */
export function resolveAlpha(state: Record<string, any>, config: ProteinsConfig): number {
  if (config.alphaMode === 'fixed') return config.alpha;

  if (state.food <= 0) return 0;

  const ratio = (state.proteins * config.hillK) / state.food;
  return config.alphaSS / (1 + ratio ** config.hillH);
}

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
  const alpha = resolveAlpha(state, config);
  state.currentAlpha = alpha;

  const u = rng();

  if (u <= alpha) {
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
