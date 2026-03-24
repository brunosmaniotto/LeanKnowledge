import Mathlib

/-- A two-period production set specifying technological possibilities.
    Production plans cover two consecutive periods ('before' and 'after'),
    where negative entries represent inputs and positive entries represent outputs. -/
structure TwoPeriodProductionSet (L : ℕ) where
  /-- The production set Y ⊂ ℝ^L × ℝ^L, where each element is a pair (y_b, y_a)
      of before-period and after-period production plans. -/
  Y : Set (Fin L → ℝ) × (Fin L → ℝ)