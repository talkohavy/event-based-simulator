import { useState } from 'react';
import ConfigPanel from './content/ConfigPanel';
import EventLogTable from './content/EventLogTable';
import StepChart from './content/StepChart';
import SummaryPanel from './content/SummaryPanel';
import { CARD, DEFAULT_CONFIG } from './logic/constants';
import { runMM1Simulation, type MM1Config } from './presets/mm1Queue';
import type { SimulationResults } from '@src/lib/simulation';

export default function SimulationPage() {
  const [config, setConfig] = useState<MM1Config>(DEFAULT_CONFIG);
  const [results, setResults] = useState<SimulationResults | null>(null);
  const [isRunning, setIsRunning] = useState(false);

  const handleConfigChange = (newConfig: MM1Config) => {
    setConfig(newConfig);
    setResults(null);
  };

  const handleRun = () => {
    setIsRunning(true);
    setTimeout(() => {
      try {
        setResults(runMM1Simulation(config));
      } catch (err) {
        console.error('Simulation error:', err);
      } finally {
        setIsRunning(false);
      }
    }, 10);
  };

  const queueData = results?.timedStats?.queueLength;

  return (
    <div className='size-full flex flex-col gap-6 overflow-auto p-6'>
      <div>
        <h1 className='text-2xl font-bold'>Event-Based Simulation</h1>
        <p className='mt-1 text-sm text-gray-500 dark:text-gray-400'>
          Generic discrete-event simulation engine — M/M/1 queue demo
        </p>
      </div>

      <div className='grid grid-cols-1 gap-6 lg:grid-cols-2'>
        <ConfigPanel config={config} onChange={handleConfigChange} onRun={handleRun} isRunning={isRunning} />
        {results ? (
          <SummaryPanel results={results} config={config} />
        ) : (
          <div className={`${CARD} flex items-center justify-center text-gray-400 dark:text-gray-600`}>
            Run a simulation to see results
          </div>
        )}
      </div>

      {queueData && <StepChart data={queueData} title='Queue Length Over Time' yLabel='Queue Length' />}

      {results && <EventLogTable events={results.eventLog} />}
    </div>
  );
}
