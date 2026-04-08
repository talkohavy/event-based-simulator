export type AlphaMode = 'fixed' | 'dynamic';

export type ProteinsConfig = {
  /** Whether alpha is a fixed constant or computed via the Hill function. */
  alphaMode: AlphaMode;
  /** Fixed-mode: probability that a protein chooses to duplicate (vs create food). */
  alpha: number;
  /**
   * Dynamic-mode: steady-state alpha — the maximum probability of duplicating
   * when food is infinitely plentiful relative to proteins.
   */
  alphaSS: number;
  /**
   * Dynamic-mode: Hill coefficient — controls how sharply alpha drops
   * as proteins outgrow food. Higher h = sharper switch.
   */
  hillH: number;
  /**
   * Dynamic-mode: scaling constant k.
   * alpha = alphaSS / (1 + (proteins * k / food) ^ h)
   */
  hillK: number;
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
