import { CARD } from '../../../Simulation/logic/constants';
import { fmt } from '../../../Simulation/logic/utils/fmt';
import type { SimulationResults } from '../../../../lib/simulation';
import type { ProteinsConfig } from '../../../Simulation/presets/proteins';

type SummaryPanelProps = {
  results: SimulationResults;
  config: ProteinsConfig;
};

export default function SummaryPanel(props: SummaryPanelProps) {
  const { results, config } = props;

  const { finalState, eventsProcessed, clock } = results;

  const alphaRow =
    config.alphaMode === 'dynamic'
      ? { label: 'Final α (Hill)', value: fmt(finalState.currentAlpha, 4) }
      : { label: 'α (fixed)', value: fmt(config.alpha, 4) };

  const rows = [
    { label: 'Final protein count (P)', value: String(finalState.proteins) },
    { label: 'Final food count (F)', value: String(finalState.food) },
    { label: 'Sleeping proteins at end', value: String(finalState.sleeping) },
    alphaRow,
    { label: 'Doublings from P₀', value: fmt(Math.log2(finalState.proteins / config.proteinsStart), 2) },
    { label: 'Avg P (time-weighted)', value: fmt(results.timeWeightedAverages.proteins ?? 0, 3) },
    { label: 'Avg F (time-weighted)', value: fmt(results.timeWeightedAverages.food ?? 0, 3) },
    { label: 'Events processed', value: String(eventsProcessed) },
    { label: 'Final clock (min)', value: fmt(clock, 3) },
  ];

  return (
    <div className={`${CARD} flex flex-col gap-3`}>
      <h2 className='text-lg font-semibold'>Results</h2>
      <table className='w-full text-sm'>
        <tbody>
          {rows.map((r) => (
            <tr key={r.label} className='border-b border-gray-100 dark:border-gray-800'>
              <td className='py-1.5 text-gray-700 dark:text-gray-300'>{r.label}</td>
              <td className='py-1.5 text-right font-mono font-semibold'>{r.value}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
