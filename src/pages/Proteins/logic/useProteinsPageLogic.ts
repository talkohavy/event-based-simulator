import { useMemo, useState } from 'react';
import { downsample } from '../../Simulation/logic/utils/downsample';
import { DEFAULT_PROTEINS_CONFIG, runProteinSimulation, type ProteinsConfig } from '../../Simulation/presets/proteins';
import { MAX_CHART_POINTS } from './constants';
import type { SimulationResults } from '../../../lib/simulation';
import type { LineSeries } from '@talkohavy/charts';

export function useProteinsPageLogic() {
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
    const rawAlpha = results.timedStats.alpha ?? [];

    const sample = <T>(arr: T[]) => (arr.length > MAX_CHART_POINTS ? downsample(arr, MAX_CHART_POINTS) : arr);

    const series: Array<LineSeries> = [
      {
        name: 'Proteins (P)',
        data: sample(rawProteins).map((pt) => ({ x: pt.time, y: pt.value })),
        color: '#7c3aed',
        lineWidth: 2,
        dots: { r: 0 },
      },
      {
        name: 'Food (F)',
        data: sample(rawFood).map((pt) => ({ x: pt.time, y: pt.value })),
        color: '#059669',
        lineWidth: 2,
        dots: { r: 0 },
      },
    ];

    if (config.alphaMode === 'dynamic' && rawAlpha.length > 0) {
      series.push({
        name: 'α (dynamic)',
        data: sample(rawAlpha).map((pt) => ({ x: pt.time, y: pt.value })),
        color: '#d97706',
        lineWidth: 1.5,
        isDashed: true,
        dots: { r: 0 },
      });
    }

    return series;
  }, [results, config.alphaMode]);

  return { config, handleConfigChange, handleRun, results, isRunning, chartData };
}
