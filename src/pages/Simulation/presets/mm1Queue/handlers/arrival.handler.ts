import { Mm1EventTypes } from '../../../logic/constants';
import type { SimulationContext } from '../../../../../lib/simulation';

export function arrivalHandler(arrivalRate: number, serviceRate: number) {
  return (props: SimulationContext) => {
    const { clock, event, state, schedule, distributions, stats } = props;

    const customerId = event.data!.customerId as number;
    state.totalArrivals++;

    const interArrival = distributions.exponential(arrivalRate);
    schedule(interArrival, Mm1EventTypes.Arrival, { customerId: customerId + 1 });

    if (!state.serverBusy) {
      state.serverBusy = true;
      const serviceTime = distributions.exponential(serviceRate);
      schedule(serviceTime, Mm1EventTypes.Departure, { customerId, arrivalTime: clock });
      stats.record('waitTime', 0);
    } else {
      state.queue.push({ customerId, arrivalTime: clock });
    }

    stats.recordTimeSeries('queueLength', clock, state.queue.length);
    stats.recordTimeSeries('serverBusy', clock, 1);
  };
}
