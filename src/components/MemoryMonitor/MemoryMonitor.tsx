import clsx from 'clsx';
import NotSupported from './content/NotSupported/NotSupported';
import ProgressBar from './content/ProgressBar';
import { POSITION_CLASSES } from './logic/constants';
import { useMemoryMonitorLogic } from './logic/useMemoryMonitorLogic';
import { getBarColor } from './logic/utils/getBarColor';
import { getTextColor } from './logic/utils/getTextColor';
import type { MemoryMonitorProps } from './types';

export function MemoryMonitor(props: MemoryMonitorProps) {
  const { position = 'bottom-right', intervalMs = 1000 } = props;

  const { snapshot, isSupported } = useMemoryMonitorLogic({ intervalMs });

  if (!isSupported) {
    return <NotSupported position={position} />;
  }

  if (!snapshot) return null;

  const { usedMB, totalMB, limitMB, usedPercent } = snapshot;

  const barColor = getBarColor(usedPercent);
  const textColor = getTextColor(usedPercent);

  return (
    <div
      className={clsx(
        'fixed z-9999 w-52 rounded-lg border border-white/10 bg-black/80 p-3 font-mono text-xs shadow-lg backdrop-blur-sm',
        POSITION_CLASSES[position],
      )}
    >
      <div className='mb-2 flex items-center justify-between'>
        <span className='font-semibold tracking-wider text-white'>MEM MONITOR</span>
        <span className={clsx('font-bold', textColor)}>{usedPercent}%</span>
      </div>

      <ProgressBar usedPercent={usedPercent} barColor={barColor} />

      {/* Stats */}
      <div className='flex flex-col gap-1 text-gray-400'>
        <div className='flex justify-between'>
          <span>Used</span>
          <span className={clsx('font-medium', textColor)}>{usedMB} MB</span>
        </div>

        <div className='flex justify-between'>
          <span>Allocated</span>
          <span className='text-gray-300'>{totalMB} MB</span>
        </div>

        <div className='flex justify-between'>
          <span>Limit</span>
          <span className='text-gray-500'>{limitMB} MB</span>
        </div>
      </div>
    </div>
  );
}
