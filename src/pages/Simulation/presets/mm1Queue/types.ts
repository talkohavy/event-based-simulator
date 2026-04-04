export type MM1Config = {
  arrivalRate: number; // λ — average arrivals per time unit
  serviceRate: number; // μ — average services per time unit
  maxTime: number;
  seed: number;
};
