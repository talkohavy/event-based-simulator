import { useMemo } from 'react';
import { Table, createColumnHelper } from '@talkohavy/table';
import { CARD, MAX_LOG_DISPLAY } from '../../logic/constants';
import { formatEventData } from '../../logic/utils/formatEventData';
import type { SimulationEvent, SimulationResults } from '../../../../lib/simulation';

type EventLogRow = SimulationEvent & { rowNum: number };

const columnHelper = createColumnHelper<EventLogRow>();

const eventLogColumns = [
  columnHelper.accessor('rowNum', {
    header: '#',
    cell: (info) => <span className='text-gray-400'>{info.getValue()}</span>,
  }),
  columnHelper.accessor('time', {
    header: 'Time',
    cell: (info) => info.getValue().toFixed(4),
  }),
  columnHelper.accessor('type', {
    header: 'Event',
    cell: (info) => {
      const type = info.getValue();
      return (
        <span
          className={type === 'arrival' ? 'text-blue-600 dark:text-blue-400' : 'text-emerald-600 dark:text-emerald-400'}
        >
          {type}
        </span>
      );
    },
  }),
  columnHelper.accessor('data', {
    header: 'Data',
    cell: (info) => {
      const data = info.getValue();
      return <span className='text-gray-500 dark:text-gray-400'>{data ? formatEventData(data) : '—'}</span>;
    },
    meta: { className: 'flex-1' },
  }),
];

export default function EventLogTable({ events }: { events: SimulationResults['eventLog'] }) {
  const data = useMemo(() => {
    const displayed = events.slice(0, MAX_LOG_DISPLAY);
    return displayed.map((ev, i) => ({ ...ev, rowNum: i + 1 }));
  }, [events]);

  return (
    <div className={CARD}>
      <h2 className='mb-3 text-lg font-semibold'>
        Event Log{' '}
        <span className='text-sm font-normal text-gray-500 dark:text-gray-400'>
          {events.length > MAX_LOG_DISPLAY
            ? `(showing ${MAX_LOG_DISPLAY} of ${events.length})`
            : `(${events.length} events)`}
        </span>
      </h2>

      <div className='h-80 overflow-auto font-mono text-xs'>
        <Table data={data} columnDefs={eventLogColumns} className='size-full' allowColumnResizing />
      </div>
    </div>
  );
}
