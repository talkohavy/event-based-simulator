import { useEffect, useState } from 'react';
import { getMemorySnapshot } from './utils/getMemorySnapshot';
import type { MemorySnapshot, UseMemoryMonitorOptions } from '../types';

export function useMemoryMonitorLogic(props: UseMemoryMonitorOptions) {
  const { intervalMs = 2000 } = props;

  const [snapshot, setSnapshot] = useState<MemorySnapshot | null>(getMemorySnapshot);

  const isSupported = 'memory' in performance;

  useEffect(() => {
    if (!isSupported) return;

    const id = setInterval(() => {
      setSnapshot(getMemorySnapshot());
    }, intervalMs);

    return () => clearInterval(id);
  }, [isSupported, intervalMs]);

  return { snapshot, isSupported };
}
