import { fmt } from './fmt';

export function formatEventData(data: Record<string, any>): string {
  return Object.entries(data)
    .map(([k, v]) => `${k}: ${typeof v === 'number' ? fmt(v, 2) : v}`)
    .join(', ');
}
