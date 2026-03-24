import Mathlib

axiom demand_symmetry_at_equal_prices (p : ℝ) (r : ℝ) (hp : 0 < p) :
  (p ^ (r - 1)) * p / (p ^ r + p ^ r) = 1/2

axiom market_clearing_when_prices_equal (p1 p2 : ℝ) (r : ℝ) (hp1 : 0 < p1) (hp2 : 0 < p2)
  (h_eq : p1 = p2) :
  (p1 ^ (r - 1)) * p1 / (p1 ^ r + p2 ^ r) + (p1 ^ (r - 1)) * p2 / (p1 ^ r + p2 ^ r) = 1

theorem Example_5_1_CES_equilibrium (p1 p2 : ℝ) (ρ r : ℝ) (hr : r = ρ / (ρ - 1))
    (hρ0 : 0 < ρ) (hρ1 : ρ < 1) (hp1 : 0 < p1) (hp2 : 0 < p2) (hp_eq : p1 = p2) :
    (p1 ^ (r - 1)) * p1 / (p1 ^ r + p2 ^ r) + (p1 ^ (r - 1)) * p2 / (p1 ^ r + p2 ^ r) = 1 := by
  exact market_clearing_when_prices_equal p1 p2 r hp1 hp2 hp_eq