import { CARD } from '../../logic/constants';
import { downsample } from '../../logic/utils/downsample';
import { integerTicks } from '../../logic/utils/integerTicks';
import { niceTimeTicks } from '../../logic/utils/niceTimeTicks';

type StepChartProps = {
  data: Array<{ time: number; value: number }>;
  title: string;
  xLabel?: string;
  yLabel?: string;
};

export default function StepChart(props: StepChartProps) {
  const { data, title, xLabel = 'Time', yLabel = '' } = props;

  if (!data || data.length === 0) return null;

  const displayData = data.length > 2000 ? downsample(data, 2000) : data;

  const vw = 800;
  const vh = 280;
  const pad = { t: 25, r: 20, b: 45, l: 55 };
  const w = vw - pad.l - pad.r;
  const h = vh - pad.t - pad.b;

  const maxTime = displayData[displayData.length - 1]!.time;
  const maxVal = Math.max(...displayData.map((d) => d.value), 1);

  const sx = (t: number) => pad.l + (t / maxTime) * w;
  const sy = (v: number) => pad.t + h - (v / maxVal) * h;

  const first = displayData[0]!;
  let linePath = `M ${sx(first.time)} ${sy(first.value)}`;
  for (let i = 1; i < displayData.length; i++) {
    const pt = displayData[i]!;
    linePath += ` H ${sx(pt.time)} V ${sy(pt.value)}`;
  }
  linePath += ` H ${sx(maxTime)}`;

  const fillPath = `${linePath} V ${sy(0)} H ${sx(first.time)} Z`;

  const yTicks = integerTicks(maxVal);
  const xTicks = niceTimeTicks(0, maxTime, 6);

  return (
    <div className={CARD}>
      <h2 className='mb-3 text-lg font-semibold'>{title}</h2>
      <svg
        viewBox={`0 0 ${vw} ${vh}`}
        className='w-full text-gray-700 dark:text-gray-300'
        preserveAspectRatio='xMinYMin meet'
      >
        <defs>
          <linearGradient id='stepFill' x1='0' y1='0' x2='0' y2='1'>
            <stop offset='0%' stopColor='rgb(99,102,241)' stopOpacity={0.25} />
            <stop offset='100%' stopColor='rgb(99,102,241)' stopOpacity={0.03} />
          </linearGradient>
        </defs>

        {/* Grid */}
        {yTicks.map((tick) => (
          <line
            key={`y${tick}`}
            x1={pad.l}
            y1={sy(tick)}
            x2={vw - pad.r}
            y2={sy(tick)}
            stroke='currentColor'
            strokeOpacity={0.08}
          />
        ))}

        {/* Data */}
        <path d={fillPath} fill='url(#stepFill)' />
        <path d={linePath} fill='none' stroke='rgb(99,102,241)' strokeWidth={1.5} />

        {/* Axes */}
        <line x1={pad.l} y1={pad.t + h} x2={vw - pad.r} y2={pad.t + h} stroke='currentColor' strokeOpacity={0.2} />
        <line x1={pad.l} y1={pad.t} x2={pad.l} y2={pad.t + h} stroke='currentColor' strokeOpacity={0.2} />

        {/* Y labels */}
        {yTicks.map((tick) => (
          <text
            key={`yl${tick}`}
            x={pad.l - 8}
            y={sy(tick) + 4}
            textAnchor='end'
            className='fill-current text-[11px] opacity-50'
          >
            {tick}
          </text>
        ))}

        {/* X labels */}
        {xTicks.map((tick) => (
          <text
            key={`xl${tick}`}
            x={sx(tick)}
            y={pad.t + h + 20}
            textAnchor='middle'
            className='fill-current text-[11px] opacity-50'
          >
            {Number.isInteger(tick) ? tick : tick.toFixed(1)}
          </text>
        ))}

        {/* Axis titles */}
        <text x={vw / 2} y={vh - 4} textAnchor='middle' className='fill-current text-xs opacity-40'>
          {xLabel}
        </text>
        {yLabel && (
          <text
            x={14}
            y={pad.t + h / 2}
            textAnchor='middle'
            transform={`rotate(-90, 14, ${pad.t + h / 2})`}
            className='fill-current text-xs opacity-40'
          >
            {yLabel}
          </text>
        )}
      </svg>
    </div>
  );
}
