import { lazy } from 'react';
import type { Route } from './common/types';

// Main pages
const HomePage = lazy(() => import('./pages/Home'));

export const routes: Array<Route> = [
  {
    to: 'home',
    text: 'Home',
    Component: HomePage,
  },
];
