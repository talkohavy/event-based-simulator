import { CARD } from '../../logic/constants';
import { fmt } from '../../logic/utils/fmt';
import type { MM1Config } from '../../presets/mm1Queue';

export default function ConfigPanel({
  config,
  onChange,
  onRun,
  isRunning,
}: {
  config: MM1Config;
  onChange: (c: MM1Config) => void;
  onRun: () => void;
  isRunning: boolean;
}) {
  const rho = config.arrivalRate / config.serviceRate;

  const inputClass =
    'w-full rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500';

  const field = (label: string, value: number, key: keyof MM1Config, step = 0.1, min = 0.01) => (
    <label className='flex flex-col gap-1'>
      <span className='text-sm font-medium text-gray-700 dark:text-gray-300'>{label}</span>
      <input
        type='number'
        className={inputClass}
        value={value}
        step={step}
        min={min}
        onChange={(e) => onChange({ ...config, [key]: Number(e.target.value) })}
      />
    </label>
  );

  return (
    <div className={`${CARD} flex flex-col gap-4`}>
      <h2 className='text-lg font-semibold'>Configuration</h2>
      <p className='text-xs text-gray-500 dark:text-gray-400'>M/M/1 Single-Server Queue</p>

      {field('Arrival Rate (λ)', config.arrivalRate, 'arrivalRate')}
      {field('Service Rate (μ)', config.serviceRate, 'serviceRate')}
      {field('Simulation Duration', config.maxTime, 'maxTime', 10, 1)}
      {field('Random Seed', config.seed, 'seed', 1, 0)}

      <div className='rounded-lg bg-gray-50 dark:bg-gray-800 p-3 text-sm'>
        <span className='font-medium'>ρ = λ/μ = {fmt(rho, 3)}</span>
        {rho >= 1 ? (
          <p className='mt-1 text-amber-600 dark:text-amber-400 text-xs'>
            ⚠ System is unstable (ρ ≥ 1). Queue will grow without bound.
          </p>
        ) : (
          <p className='mt-1 text-emerald-600 dark:text-emerald-400 text-xs'>
            System is stable. Utilization ≈ {fmt(rho * 100, 1)}%
          </p>
        )}
      </div>

      <button
        type='button'
        onClick={onRun}
        disabled={isRunning}
        className='mt-2 w-full cursor-pointer rounded-lg bg-indigo-600 px-6 py-2.5 text-sm font-medium text-white transition-colors hover:bg-indigo-700 disabled:cursor-not-allowed disabled:opacity-50'
      >
        {isRunning ? 'Running…' : '▶  Run Simulation'}
      </button>
    </div>
  );
}
