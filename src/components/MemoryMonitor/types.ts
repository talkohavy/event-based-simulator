export type MemorySnapshot = {
  usedMB: number;
  totalMB: number;
  limitMB: number;
  usedPercent: number;
};

export type UseMemoryMonitorOptions = {
  /**
   * Polling interval in milliseconds.
   * @default 2000
   */
  intervalMs?: number;
};

export type Position = 'top-left' | 'top-right' | 'bottom-left' | 'bottom-right';

export interface MemoryMonitorProps {
  /**
   * Corner of the viewport to anchor the widget.
   * @default 'bottom-right'
   */
  position?: Position;
  /**
   * Polling interval in milliseconds.
   * @default 2000
   */
  intervalMs?: number;
}
