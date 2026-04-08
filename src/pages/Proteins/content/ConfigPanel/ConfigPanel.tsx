import { CARD } from '../../../Simulation/logic/constants';
import { fmt } from '../../../Simulation/logic/utils/fmt';
import type { ProteinsConfig } from '../../../Simulation/presets/proteins';
import type { AlphaMode } from '../../../Simulation/presets/proteins/types';

type ConfigPanelProps = {
  config: ProteinsConfig;
  onChange: (c: ProteinsConfig) => void;
  onRun: () => void;
  isRunning: boolean;
};

export default function ConfigPanel(props: ConfigPanelProps) {
  const { config, onChange, onRun, isRunning } = props;

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

  const isDynamic = config.alphaMode === 'dynamic';

  return (
    <div className={`${CARD} flex flex-col gap-4`}>
      <div>
        <h2 className='text-lg font-semibold'>Configuration</h2>
        <p className='text-xs text-gray-500 dark:text-gray-400 mt-0.5'>Protein Growth Simulation</p>
      </div>

      {/* Alpha mode toggle */}
      <div className='flex rounded-lg overflow-hidden border border-gray-300 dark:border-gray-600 text-sm font-medium'>
        {(['fixed', 'dynamic'] as AlphaMode[]).map((mode) => (
          <button
            key={mode}
            type='button'
            onClick={() => onChange({ ...config, alphaMode: mode })}
            className={`flex-1 py-2 transition-colors cursor-pointer capitalize ${
              config.alphaMode === mode
                ? 'bg-violet-600 text-white'
                : 'bg-white dark:bg-gray-800 text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700'
            }`}
          >
            {mode === 'fixed' ? 'Fixed α' : 'Dynamic α (Hill)'}
          </button>
        ))}
      </div>

      {/* Alpha fields */}
      {!isDynamic ? (
        <div>{field('α — duplicate probability', 'alpha', 0.01, 0)}</div>
      ) : (
        <div className='grid grid-cols-3 gap-3'>
          {field('αSS (steady-state)', 'alphaSS', 0.01, 0)}
          {field('h (Hill exponent)', 'hillH', 0.5, 0.5)}
          {field('k (scaling factor)', 'hillK', 0.1, 0.1)}
        </div>
      )}

      <div className='rounded-lg bg-violet-50 dark:bg-violet-950/30 border border-violet-200 dark:border-violet-800 p-3 text-xs text-violet-700 dark:text-violet-300 space-y-1'>
        {isDynamic ? (
          <>
            <p className='font-semibold font-mono'>α = αSS / (1 + (P·k / F)^h)</p>
            <p>
              Alpha adapts at every decision — when food is scarce relative to proteins, α collapses toward 0, shifting
              all effort into food production. When food is abundant, α rises toward αSS.
            </p>
          </>
        ) : (
          <p>
            <span className='font-semibold'>α = {fmt(config.alpha, 3)}</span> — constant probability. Each free protein
            draws a uniform random number; if it falls below α <em>and</em> food is available, it duplicates.
          </p>
        )}
        <p className='pt-0.5'>Proteins waiting to duplicate but finding no food will sleep until food arrives.</p>
      </div>

      {/* Common fields */}
      <div className='grid grid-cols-2 gap-3'>
        {field('Proteins at t=0 (P₀)', 'proteinsStart', 1, 1)}
        {field('Food at t=0 (F₀)', 'foodStart', 1, 0)}
        {field('Mean food time (min)', 'meanFoodTime', 0.1, 0.01)}
        {field('Mean duplicate time (min)', 'meanDuplicateTime', 0.01, 0.001)}
        {field('Max time (min)', 'maxTime', 10, 1)}
        {field('Max proteins (stop)', 'maxProteins', 1, 2)}
        {field('Random seed', 'seed', 1, 0)}
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
