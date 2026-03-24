import Mathlib

/-- A choice function maps a price vector and scalar income to a consumption
    bundle. Unlike a demand function, it is not derived from utility
    maximisation — it is defined purely in terms of observable choice
    behaviour. (MWG §2.3) -/
def ChoiceFunction (L : ℕ) :=
  (Fin L → ℝ) → ℝ → (Fin L → ℝ)