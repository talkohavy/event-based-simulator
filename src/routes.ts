import { lazy } from 'react';
import type { Route } from './common/types';

// Main pages
const HomePage = lazy(() => import('./pages/Home'));
const SimulationPage = lazy(() => import('./pages/Simulation'));
const ProteinsPage = lazy(() => import('./pages/Proteins'));

export const routes: Array<Route> = [
  {
    to: 'home',
    text: 'Home',
    Component: HomePage,
  },
  {
    to: 'simulation',
    text: 'Simulation',
    Component: SimulationPage,
  },
  {
    to: 'proteins',
    text: 'Proteins',
    Component: ProteinsPage,
  },
];
