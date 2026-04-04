import { CARD, MAX_LOG_DISPLAY } from '../../logic/constants';
import { formatEventData } from '../../logic/utils/formatEventData';
import type { SimulationResults } from '../../../../lib/simulation';

export default function EventLogTable({ events }: { events: SimulationResults['eventLog'] }) {
  const displayed = events.slice(0, MAX_LOG_DISPLAY);

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

      <div className='max-h-80 overflow-auto'>
        <table className='w-full text-sm'>
          <thead className='sticky top-0 bg-white dark:bg-gray-900'>
            <tr className='border-b border-gray-200 dark:border-gray-700 text-xs uppercase text-gray-500 dark:text-gray-400'>
              <th className='py-2 pr-4 text-left'>#</th>
              <th className='py-2 pr-4 text-left'>Time</th>
              <th className='py-2 pr-4 text-left'>Event</th>
              <th className='py-2 text-left'>Data</th>
            </tr>
          </thead>
          <tbody className='font-mono text-xs'>
            {displayed.map((ev, i) => (
              <tr key={ev.id} className='border-b border-gray-50 dark:border-gray-800'>
                <td className='py-1 pr-4 text-gray-400'>{i + 1}</td>
                <td className='py-1 pr-4'>{ev.time.toFixed(4)}</td>
                <td className='py-1 pr-4'>
                  <span
                    className={
                      ev.type === 'arrival'
                        ? 'text-blue-600 dark:text-blue-400'
                        : 'text-emerald-600 dark:text-emerald-400'
                    }
                  >
                    {ev.type}
                  </span>
                </td>
                <td className='py-1 text-gray-500 dark:text-gray-400'>{ev.data ? formatEventData(ev.data) : '—'}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}
