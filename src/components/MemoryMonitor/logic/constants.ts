import type { Position } from '../types';

export const MB = 1024 * 1024;

export const POSITION_CLASSES: Record<Position, string> = {
  'top-left': 'top-4 left-4',
  'top-right': 'top-4 right-4',
  'bottom-left': 'bottom-4 left-4',
  'bottom-right': 'bottom-4 right-4',
};
