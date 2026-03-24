import Mathlib

open Set Filter Topology

-- The profit for a single firm serving the entire market demand `x(p)` at price `p`.
noncomputable def single_firm_profit (K c : ℝ) (x : ℝ → ℝ) (p : ℝ) : ℝ :=
  if 0 < x p then (p - c) * x p - K else 0

-- The set of prices where a single firm can at least break even.
def BreakEvenPrices (K c : ℝ) (x : ℝ → ℝ) : Set ℝ :=
  {p | single_firm_profit K c x p ≥ 0}

-- Helper lemma: with positive demand, the profit function has a simpler form.