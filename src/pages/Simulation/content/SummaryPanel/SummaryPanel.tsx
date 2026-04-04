import { CARD } from '../../logic/constants';
import { fmt } from '../../logic/utils/fmt';
import { type MM1Config, mm1Theoretical } from '../../presets/mm1Queue';
import type { SimulationResults } from '../../../../lib/simulation';

export default function SummaryPanel({ results, config }: { results: SimulationResults; config: MM1Config }) {
  const theory = mm1Theoretical(config.arrivalRate, config.serviceRate);

  const simUtilization = results.timeWeightedAverages.serverBusy ?? 0;
  const simAvgWait = results.stats.waitTime?.mean ?? 0;
  const simAvgSystem = results.stats.systemTime?.mean ?? 0;
  const simAvgQueueLen = results.timeWeightedAverages.queueLength ?? 0;
  const simAvgInSystem = simAvgQueueLen + simUtilization;

  const rows: Array<{ label: string; simulated: string; theoretical: string }> = [
    { label: 'Utilization (ρ)', simulated: fmt(simUtilization), theoretical: fmt(theory.rho) },
    { label: 'Avg Wait in Queue (E[Wq])', simulated: fmt(simAvgWait), theoretical: fmt(theory.avgWaitInQueue) },
    { label: 'Avg Time in System (E[W])', simulated: fmt(simAvgSystem), theoretical: fmt(theory.avgTimeInSystem) },
    { label: 'Avg Queue Length (E[Lq])', simulated: fmt(simAvgQueueLen), theoretical: fmt(theory.avgQueueLength) },
    { label: 'Avg in System (E[L])', simulated: fmt(simAvgInSystem), theoretical: fmt(theory.avgNumberInSystem) },
    { label: 'Customers Served', simulated: String(results.finalState.totalServed), theoretical: '—' },
    { label: 'Events Processed', simulated: String(results.eventsProcessed), theoretical: '—' },
    { label: 'Final Clock', simulated: fmt(results.clock, 2), theoretical: '—' },
  ];

  return (
    <div className={`${CARD} flex flex-col gap-3`}>
      <h2 className='text-lg font-semibold'>Results</h2>
      <table className='w-full text-sm'>
        <thead>
          <tr className='border-b border-gray-200 dark:border-gray-700'>
            <th className='py-2 text-left font-medium text-gray-600 dark:text-gray-400'>Metric</th>
            <th className='py-2 text-right font-medium text-gray-600 dark:text-gray-400'>Simulated</th>
            <th className='py-2 text-right font-medium text-gray-600 dark:text-gray-400'>Theoretical</th>
          </tr>
        </thead>
        <tbody>
          {rows.map((r) => (
            <tr key={r.label} className='border-b border-gray-100 dark:border-gray-800'>
              <td className='py-1.5 text-gray-700 dark:text-gray-300'>{r.label}</td>
              <td className='py-1.5 text-right font-mono'>{r.simulated}</td>
              <td className='py-1.5 text-right font-mono text-gray-500 dark:text-gray-400'>{r.theoretical}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
