import { Mm1EventTypes } from '../../../logic/constants';
import type { InitContext } from '../../../../../lib/simulation';

export function initHandler(props: InitContext) {
  const { state, schedule } = props;

  state.serverBusy = false;
  state.queue = [];
  state.totalArrivals = 0;
  state.totalServed = 0;
  schedule(0, Mm1EventTypes.Arrival, { customerId: 1 });
}
