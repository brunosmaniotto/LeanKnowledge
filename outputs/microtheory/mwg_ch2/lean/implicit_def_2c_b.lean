import Mathlib

/-- The default consumption set X = ℝ₊ᴸ: all nonnegative bundles of L commodities. -/
def consumptionSet (L : ℕ) : Set (Fin L → ℝ) :=
  {x | ∀ l, 0 ≤ x l}