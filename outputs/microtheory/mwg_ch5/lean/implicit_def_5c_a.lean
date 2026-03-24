import Mathlib

/-- A price system for L goods: a strictly positive price vector,
    independent of firm production plans (price-taking assumption). -/
structure PriceSystem (L : ℕ) where
  /-- Price vector p = (p₁, ..., p_L) -/
  p : Fin L → ℝ
  /-- All prices are strictly positive: p >> 0 -/
  pos : ∀ i, 0 < p i