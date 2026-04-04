// ================================
// Simulation Engine Types
// ================================

export type SimulationEngineConstructorProps = {
  stopWhen: StopCondition;
  seed?: number;
  /**
   * Whether to record the event log.
   *
   * @default true
   */
  shouldRecordEventLog?: boolean;
};

export type ResolvedConfig = Required<SimulationEngineConstructorProps>;

export type InitContext = {
  state: Record<string, any>;
  schedule: (delay: number, type: string, data?: Record<string, any>) => number;
  scheduleAt: (absoluteTime: number, type: string, data?: Record<string, any>) => number;
  rng: () => number;
  distributions: DistributionFunctions;
};

export type SimulationResults = {
  clock: number;
  eventsProcessed: number;
  finalState: Record<string, any>;
  stats: Record<string, StatsSummary>;
  eventLog: Array<SimulationEvent>;
  timedStats: Record<string, Array<{ time: number; value: number }>>;
  timeWeightedAverages: Record<string, number>;
};

export type EventHandler = (ctx: SimulationContext) => void;

export type SimulationContext = {
  clock: number;
  event: SimulationEvent;
  state: Record<string, any>;
  stats: {
    record: (name: string, value: number) => void;
    recordTimeSeries: (name: string, time: number, value: number) => void;
  };
  schedule: (delay: number, type: string, data?: Record<string, any>) => number;
  scheduleAt: (absoluteTime: number, type: string, data?: Record<string, any>) => number;
  cancelEvent: (eventId: number) => void;
  rng: () => number;
  distributions: DistributionFunctions;
};

type StopCondition = (info: { clock: number; eventsProcessed: number; state: Record<string, any> }) => boolean;

export type SimulationEvent = {
  id: number;
  time: number;
  type: string;
  data?: Record<string, any>;
};

// ================================
// createDistributions Types
// ================================

export type DistributionFunctions = {
  exponential: (rate: number) => number;
  uniform: (min: number, max: number) => number;
  normal: (mean: number, stddev: number) => number;
  triangular: (min: number, mode: number, max: number) => number;
  bernoulli: (p: number) => boolean;
  poisson: (lambda: number) => number;
};

// ================================

export type StatsSummary = {
  name: string;
  count: number;
  mean: number;
  variance: number;
  stddev: number;
  min: number;
  max: number;
};
