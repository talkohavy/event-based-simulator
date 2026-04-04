import type { MM1Config } from '../presets/mm1Queue/types';

export const DEFAULT_CONFIG: MM1Config = {
  arrivalRate: 5,
  serviceRate: 8,
  maxTime: 100,
  seed: 42,
};

export const MAX_LOG_DISPLAY = 200;

export const CARD = 'rounded-xl border border-gray-200 dark:border-gray-700 bg-white dark:bg-gray-900 p-6 shadow-sm';

export const Mm1EventTypes = {
  Arrival: 'arrival',
  Departure: 'departure',
} as const;
