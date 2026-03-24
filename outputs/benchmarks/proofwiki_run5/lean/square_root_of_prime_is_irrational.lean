import Mathlib

lemma irrational_def_equiv (x : ℝ) : Irrational x ↔ x ∉ Set.range (Rat.cast : ℚ → ℝ) := by
  rfl