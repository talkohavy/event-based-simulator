import { Mm1EventTypes } from '../../../logic/constants';
import type { SimulationContext } from '../../../../../lib/simulation';

export function departureHandler(serviceRate: number) {
  return (props: SimulationContext) => {
    const { clock, event, state, schedule, distributions, stats } = props;

    state.totalServed++;
    stats.record('systemTime', clock - (event.data!.arrivalTime as number));

    if (state.queue.length > 0) {
      const next = state.queue.shift()!;
      stats.record('waitTime', clock - next.arrivalTime);
      const serviceTime = distributions.exponential(serviceRate);
      schedule(serviceTime, Mm1EventTypes.Departure, {
        customerId: next.customerId,
        arrivalTime: next.arrivalTime,
      });
    } else {
      state.serverBusy = false;
    }

    stats.recordTimeSeries('queueLength', clock, state.queue.length);
    stats.recordTimeSeries('serverBusy', clock, state.serverBusy ? 1 : 0);
  };
}
