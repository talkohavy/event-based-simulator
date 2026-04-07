export type ProteinsConfig = {
  /** Probability that a protein chooses to duplicate (vs create food). */
  alpha: number;
  /** Number of proteins at t=0. */
  proteinsStart: number;
  /** Number of food units at t=0. */
  foodStart: number;
  /** Mean time (minutes) for a protein to create one food unit — Exp(1/meanFoodTime). */
  meanFoodTime: number;
  /** Mean time (minutes) for a protein to duplicate — Exp(1/meanDuplicateTime). */
  meanDuplicateTime: number;
  /** Simulation stops when the clock exceeds this value (minutes). */
  maxTime: number;
  /** Simulation stops when the protein count reaches this. */
  maxProteins: number;
  seed: number;
};
