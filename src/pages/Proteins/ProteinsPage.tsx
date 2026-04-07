import { useMemo, useState } from 'react';
import { LineChart, type LineSeries } from '@talkohavy/charts';
import { downsample } from '../Simulation/logic/utils/downsample';
import { DEFAULT_PROTEINS_CONFIG, runProteinSimulation, type ProteinsConfig } from '../Simulation/presets/proteins';
import type { SimulationResults } from '@src/lib/simulation';

const CARD = 'rounded-xl border border-gray-200 dark:border-gray-700 bg-white dark:bg-gray-900 p-6 shadow-sm';
const MAX_CHART_POINTS = 1500;

function fmt(n: number, d = 2) {
  return Number.isFinite(n) ? n.toFixed(d) : '∞';
}

function ConfigPanel({
  config,
  onChange,
  onRun,
  isRunning,
}: {
  config: ProteinsConfig;
  onChange: (c: ProteinsConfig) => void;
  onRun: () => void;
  isRunning: boolean;
}) {
  const inputClass =
    'w-full rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-violet-500';

  function field(label: string, key: keyof ProteinsConfig, step = 0.01, min = 0) {
    return (
      <label className='flex flex-col gap-1'>
        <span className='text-sm font-medium text-gray-700 dark:text-gray-300'>{label}</span>
        <input
          type='number'
          className={inputClass}
          value={config[key] as number}
          step={step}
          min={min}
          onChange={(e) => onChange({ ...config, [key]: Number(e.target.value) })}
        />
      </label>
    );
  }

  return (
    <div className={`${CARD} flex flex-col gap-4`}>
      <div>
        <h2 className='text-lg font-semibold'>Configuration</h2>
        <p className='text-xs text-gray-500 dark:text-gray-400 mt-0.5'>Protein Growth Simulation</p>
      </div>

      <div className='grid grid-cols-2 gap-3'>
        {field('α (duplicate probability)', 'alpha', 0.01, 0)}
        {field('Proteins at t=0 (P₀)', 'proteinsStart', 1, 1)}
        {field('Food at t=0 (F₀)', 'foodStart', 1, 0)}
        {field('Mean food time (min)', 'meanFoodTime', 0.1, 0.01)}
        {field('Mean duplicate time (min)', 'meanDuplicateTime', 0.01, 0.001)}
        {field('Max time (min)', 'maxTime', 10, 1)}
        {field('Max proteins (stop)', 'maxProteins', 1, 2)}
        {field('Random seed', 'seed', 1, 0)}
      </div>

      <div className='rounded-lg bg-violet-50 dark:bg-violet-950/30 border border-violet-200 dark:border-violet-800 p-3 text-xs text-violet-700 dark:text-violet-300 space-y-1'>
        <p>
          <span className='font-semibold'>α = {fmt(config.alpha, 3)}</span> — each free protein rolls a uniform random
          number. If it falls below α <em>and</em> food is available, it duplicates; otherwise it creates food.
        </p>
        <p>Proteins waiting to duplicate but finding no food will sleep until a food unit arrives.</p>
      </div>

      <button
        type='button'
        onClick={onRun}
        disabled={isRunning}
        className='mt-1 w-full cursor-pointer rounded-lg bg-violet-600 px-6 py-2.5 text-sm font-medium text-white transition-colors hover:bg-violet-700 disabled:cursor-not-allowed disabled:opacity-50'
      >
        {isRunning ? 'Running…' : '▶  Run Simulation'}
      </button>
    </div>
  );
}

function SummaryPanel({ results, config }: { results: SimulationResults; config: ProteinsConfig }) {
  const { finalState, eventsProcessed, clock } = results;

  const rows = [
    { label: 'Final protein count (P)', value: String(finalState.proteins) },
    { label: 'Final food count (F)', value: String(finalState.food) },
    { label: 'Sleeping proteins at end', value: String(finalState.sleeping) },
    { label: 'Events processed', value: String(eventsProcessed) },
    { label: 'Final clock (min)', value: fmt(clock, 3) },
    { label: 'Doublings from P₀', value: fmt(Math.log2(finalState.proteins / config.proteinsStart), 2) },
    { label: 'Avg F (time-weighted)', value: fmt(results.timeWeightedAverages.food ?? 0, 3) },
    { label: 'Avg P (time-weighted)', value: fmt(results.timeWeightedAverages.proteins ?? 0, 3) },
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

export default function ProteinsPage() {
  const [config, setConfig] = useState<ProteinsConfig>({ ...DEFAULT_PROTEINS_CONFIG });
  const [results, setResults] = useState<SimulationResults | null>(null);
  const [isRunning, setIsRunning] = useState(false);

  const handleConfigChange = (newConfig: ProteinsConfig) => {
    setConfig(newConfig);
    setResults(null);
  };

  const handleRun = () => {
    setIsRunning(true);
    setTimeout(() => {
      try {
        setResults(runProteinSimulation(config));
      } catch (err) {
        console.error('Simulation error:', err);
      } finally {
        setIsRunning(false);
      }
    }, 10);
  };

  const chartData = useMemo((): Array<LineSeries> => {
    if (!results) return [];

    const rawProteins = results.timedStats.proteins ?? [];
    const rawFood = results.timedStats.food ?? [];

    const proteinSampled =
      rawProteins.length > MAX_CHART_POINTS ? downsample(rawProteins, MAX_CHART_POINTS) : rawProteins;
    const foodSampled = rawFood.length > MAX_CHART_POINTS ? downsample(rawFood, MAX_CHART_POINTS) : rawFood;

    return [
      {
        name: 'Proteins (P)',
        data: proteinSampled.map((pt) => ({ x: pt.time, y: pt.value })),
        color: '#7c3aed',
        lineWidth: 2,
        dots: { r: 0 },
      },
      {
        name: 'Food (F)',
        data: foodSampled.map((pt) => ({ x: pt.time, y: pt.value })),
        color: '#059669',
        lineWidth: 2,
        dots: { r: 0 },
      },
    ];
  }, [results]);

  return (
    <div className='size-full flex flex-col gap-6 overflow-auto p-6'>
      <div>
        <h1 className='text-2xl font-bold'>Protein Growth Simulation</h1>
        <p className='mt-1 text-sm text-gray-500 dark:text-gray-400'>
          Discrete-event simulation of protein self-replication — port of an old university MATLAB experiment
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
                yValueFormatter: (v) => String(Math.round(v)),
              },
            }}
            className='rounded-lg border p-4 font-thin'
          />
        </div>
      )}
    </div>
  );
}
