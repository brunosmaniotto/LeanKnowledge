import Mathlib

/-- An insurance market where the cost of providing insurance is zero.
    Insurance companies have no administrative or operational costs. -/
structure ZeroCostInsurance where
  /-- The cost function for providing insurance coverage α -/
  cost : ℝ → ℝ
  /-- The cost is zero for all coverage levels -/
  zero_cost : ∀ α, cost α = 0