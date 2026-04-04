import { PriorityQueue } from '../PriorityQueue';
import { createDistributions } from './logic/utils/createDistributions';
import { createRandomNumberGenerator } from './logic/utils/createRandomNumberGenerator';
import { StatisticsCollector } from './logic/utils/StatisticsCollector';
import type {
  SimulationEvent,
  SimulationEngineConstructorProps,
  EventHandler,
  SimulationResults,
  InitContext,
  DistributionFunctions,
  ResolvedConfig,
} from './types';

/**
 * Generic discrete-event simulation engine.
 *
 * Usage:
 * ```
 * const sim = createSimulation({ seed: 42, stopWhen: ctx => ctx.clock >= 100 });
 *
 * sim.on('arrival', ({ clock, state, schedule, distributions, stats }) => {
 *   // handle event, update state, schedule future events, record stats
 * });
 *
 * sim.init(({ state, schedule }) => {
 *   // set initial state and schedule the first event(s)
 * });
 *
 * const results = sim.run();
 * ```
 */
export class SimulationEngine {
  private clock!: number;
  private nextEventId!: number;
  private eventsProcessed!: number;
  private futureEventList!: PriorityQueue<SimulationEvent>;
  private eventLog!: SimulationEvent[];
  private state!: Record<string, any>;
  private readonly eventHandlers: Map<string, EventHandler>;
  private readonly cancelled: Set<number>;
  private initFn?: (ctx: InitContext) => void;
  private config: ResolvedConfig;
  private rng!: () => number;
  private distributions!: DistributionFunctions;
  private stats!: StatisticsCollector;

  constructor(config: SimulationEngineConstructorProps) {
    this.config = {
      stopWhen: config.stopWhen,
      seed: config.seed ?? Date.now(),
      shouldRecordEventLog: config.shouldRecordEventLog ?? true,
    };

    this.eventHandlers = new Map<string, EventHandler>();
    this.cancelled = new Set<number>();
  }

  setInitFunction(fn: (ctx: InitContext) => void) {
    this.initFn = fn;
  }

  /**
   * Executes the simulation from t=0 until the stop condition is met,
   * the futureEventList is empty, or maxEvents is reached.
   *
   * Can be called multiple times — each call resets all state.
   */
  run(): SimulationResults {
    this.reset();

    if (this.initFn) {
      this.initFn({
        state: this.state,
        schedule: this.schedule.bind(this),
        scheduleAt: this.scheduleAt.bind(this),
        rng: this.rng,
        distributions: this.distributions,
      });
    }

    while (!this.futureEventList.isEmpty()) {
      const event = this.futureEventList.dequeue()!;

      if (this.cancelled.has(event.id)) {
        this.cancelled.delete(event.id);
        continue;
      }

      this.clock = event.time;

      if (
        this.config.stopWhen({
          clock: this.clock,
          eventsProcessed: this.eventsProcessed,
          state: this.state,
        })
      ) {
        break;
      }

      if (this.config.shouldRecordEventLog) {
        this.eventLog.push({ ...event });
      }

      const eventHandler = this.eventHandlers.get(event.type);

      if (!eventHandler) throw new Error(`Handler for event type ${event.type} not found`);

      eventHandler({
        clock: this.clock,
        event,
        state: this.state,
        stats: this.stats,
        schedule: this.schedule.bind(this),
        scheduleAt: this.scheduleAt.bind(this),
        cancelEvent: this.cancelEvent.bind(this),
        rng: this.rng,
        distributions: this.distributions,
      });

      this.eventsProcessed++;
    }

    const timedStats = this.stats.getTimedSeriesData();
    const timeWeightedAverages: Record<string, number> = {};

    for (const name of Object.keys(timedStats)) {
      const avg = this.stats.getTimeWeightedAverage(name, this.clock);
      if (avg !== null) timeWeightedAverages[name] = avg;
    }

    return {
      clock: this.clock,
      eventsProcessed: this.eventsProcessed,
      finalState: { ...this.state },
      stats: this.stats.getSummary(),
      eventLog: this.eventLog,
      timedStats,
      timeWeightedAverages,
    };
  }

  on(eventType: string, handler: EventHandler) {
    this.eventHandlers.set(eventType, handler);
  }

  private reset() {
    this.clock = 0;
    this.nextEventId = 1;
    this.eventsProcessed = 0;
    this.eventLog = [];
    this.state = {};
    this.cancelled.clear();
    this.futureEventList = new PriorityQueue<SimulationEvent>((a, b) => a.time - b.time);
    this.rng = createRandomNumberGenerator(this.config.seed);
    this.distributions = createDistributions(this.rng);
    this.stats = new StatisticsCollector();
  }

  private scheduleEvent(time: number, type: string, data?: Record<string, any>): number {
    const id = this.nextEventId++;
    this.futureEventList.enqueue({ id, time, type, data });
    return id;
  }

  private schedule(delay: number, type: string, data?: Record<string, any>): number {
    return this.scheduleEvent(this.clock + delay, type, data);
  }

  private scheduleAt(absoluteTime: number, type: string, data?: Record<string, any>): number {
    return this.scheduleEvent(absoluteTime, type, data);
  }

  private cancelEvent(eventId: number): void {
    this.cancelled.add(eventId);
  }
}

export function createSimulation(config: SimulationEngineConstructorProps): SimulationEngine {
  return new SimulationEngine(config);
}
