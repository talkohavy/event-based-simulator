import type { DistributionFunctions } from '../../types';

/**
 * Creates a set of distribution samplers bound to the given RNG.
 *
 * Convention: `rate` parameters follow the standard definition where
 * E[X] = 1/rate for the exponential distribution.
 */
export function createDistributions(rng: () => number): DistributionFunctions {
  return {
    exponential(rate: number): number {
      return -Math.log(1 - rng()) / rate;
    },

    uniform(min: number, max: number): number {
      return min + (max - min) * rng();
    },

    // Box-Muller transform
    normal(mean: number, stddev: number): number {
      const u1 = rng();
      const u2 = rng();
      const z = Math.sqrt(-2 * Math.log(u1)) * Math.cos(2 * Math.PI * u2);
      return mean + stddev * z;
    },

    triangular(min: number, mode: number, max: number): number {
      const u = rng();
      const fc = (mode - min) / (max - min);
      if (u < fc) {
        return min + Math.sqrt(u * (max - min) * (mode - min));
      }
      return max - Math.sqrt((1 - u) * (max - min) * (max - mode));
    },

    bernoulli(p: number): boolean {
      return rng() < p;
    },

    poisson(lambda: number): number {
      const L = Math.exp(-lambda);
      let k = 0;
      let p = 1;
      do {
        k++;
        p *= rng();
      } while (p > L);
      return k - 1;
    },
  };
}
