import { LineChart } from '@talkohavy/charts';
import { CARD } from '../Simulation/logic/constants';
import ConfigPanel from './content/ConfigPanel';
import SummaryPanel from './content/SummaryPanel';
import { useProteinsPageLogic } from './logic/useProteinsPageLogic';

export default function ProteinsPage() {
  const { config, handleConfigChange, handleRun, results, isRunning, chartData } = useProteinsPageLogic();

  return (
    <div className='size-full flex flex-col gap-6 overflow-auto p-6'>
      <div>
        <h1 className='text-2xl font-bold'>Protein Growth Simulation</h1>
        <p className='mt-1 text-sm text-gray-500 dark:text-gray-400'>
          Discrete-event simulation of protein self-replication — port of a university MATLAB experiment
        </p>
      </div>

      <div className='grid grid-cols-1 gap-6 lg:grid-cols-2'>
        <ConfigPanel config={config} onChange={handleConfigChange} onRun={handleRun} isRunning={isRunning} />

        {results ? (
          <SummaryPanel results={results} config={config} />
        ) : (
          <div className={`${CARD} flex items-center justify-center text-gray-400 dark:text-gray-600 min-h-48`}>
            Run a simulation to see results
          </div>
        )}
      </div>

      {chartData.length > 0 && (
        <div className='w-full h-140 shrink-0'>
          <LineChart
            type='number'
            data={chartData}
            settings={{
              legend: { show: true, nameFormatter: (name) => name },
              xAxis: { label: 'Time (minutes)' },
              yAxis: { label: 'Count' },
              lines: { hideDots: true },
              tooltip: {
                xValueFormatter: (v) => `t = ${Number(v).toFixed(2)} min`,
                yValueFormatter: (v) => {
                  const n = Number(v);
                  return n < 1 ? n.toFixed(4) : String(Math.round(n));
                },
              },
            }}
            className='rounded-lg border p-4 font-thin'
          />
        </div>
      )}
    </div>
  );
}
