import { createSimulation } from '@src/lib/simulation';
import { Mm1EventTypes } from '../../logic/constants';
import { arrivalHandler, departureHandler, initHandler } from './handlers';
import type { MM1Config } from './types';
import type { SimulationResults } from '@src/lib/simulation';

/**
 * M/M/1 Single-Server Queue
 *
 * - Arrivals: Poisson process with rate λ  (inter-arrival ~ Exp(λ))
 * - Service:  Exponential with rate μ      (service time  ~ Exp(μ))
 * - 1 server, FIFO discipline
 *
 * System is stable when ρ = λ/μ < 1.
 */
export function runMM1Simulation(props: MM1Config): SimulationResults {
  const { arrivalRate, serviceRate, maxTime, seed } = props;

  const sim = createSimulation({
    stopWhen: ({ clock, eventsProcessed }) => clock >= maxTime || eventsProcessed >= 100_000,
    seed,
    shouldRecordEventLog: true,
  });

  sim.setInitFunction(initHandler);

  sim.on(Mm1EventTypes.Arrival, arrivalHandler(arrivalRate, serviceRate));
  sim.on(Mm1EventTypes.Departure, departureHandler(serviceRate));

  return sim.run();
}

/** Closed-form M/M/1 steady-state formulas (valid when ρ < 1). */
export function mm1Theoretical(arrivalRate: number, serviceRate: number) {
  const rho = arrivalRate / serviceRate;
  const stable = rho < 1;

  return {
    rho,
    stable,
    avgWaitInQueue: stable ? rho / (serviceRate - arrivalRate) : Number.POSITIVE_INFINITY,
    avgTimeInSystem: stable ? 1 / (serviceRate - arrivalRate) : Number.POSITIVE_INFINITY,
    avgQueueLength: stable ? (rho * rho) / (1 - rho) : Number.POSITIVE_INFINITY,
    avgNumberInSystem: stable ? rho / (1 - rho) : Number.POSITIVE_INFINITY,
  };
}
