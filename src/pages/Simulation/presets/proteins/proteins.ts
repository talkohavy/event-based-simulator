import { createSimulation } from '@src/lib/simulation';
import { ProteinEventTypes } from './constants';
import { foodCreatedHandler, initHandler, proteinDuplicatedHandler } from './handlers';
import type { ProteinsConfig } from './types';
import type { SimulationResults } from '@src/lib/simulation';

/**
 * Protein Growth Simulation
 *
 * Models a population of proteins (P) and food units (F).
 * Each protein independently chooses one of two actions:
 *   - With probability α: duplicate (consumes 1 food, produces a new protein)
 *   - With probability 1-α: produce food (adds 1 food unit)
 *
 * A protein that wants to duplicate but finds no food available will sleep
 * until the next food unit arrives.
 *
 * Stops when the clock exceeds maxTime or proteins reach maxProteins.
 */
export function runProteinSimulation(config: ProteinsConfig): SimulationResults {
  const sim = createSimulation({
    stopWhen: ({ clock, state }) => clock >= config.maxTime || state.proteins >= config.maxProteins,
    seed: config.seed,
    shouldRecordEventLog: false,
  });

  sim.setInitFunction(initHandler(config));

  sim.on(ProteinEventTypes.FoodCreated, foodCreatedHandler(config));
  sim.on(ProteinEventTypes.ProteinDuplicated, proteinDuplicatedHandler(config));

  return sim.run();
}
