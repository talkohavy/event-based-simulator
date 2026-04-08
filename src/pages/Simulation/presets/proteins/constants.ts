export const ProteinEventTypes = {
  FoodCreated: 'food_created',
  ProteinDuplicated: 'protein_duplicated',
} as const;

export const DEFAULT_PROTEINS_CONFIG = {
  alphaMode: 'fixed',
  alpha: 0.285,
  alphaSS: 0.28,
  hillH: 2,
  hillK: 1,
  proteinsStart: 4,
  foodStart: 0,
  meanFoodTime: 6,
  meanDuplicateTime: 0.1167,
  maxTime: 960,
  maxProteins: 512,
  seed: 71,
} as const;
