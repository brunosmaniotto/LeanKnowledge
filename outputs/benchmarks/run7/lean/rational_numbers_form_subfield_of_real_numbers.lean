import Mathlib

theorem rationals_form_ordered_subfield :
    ∃ (S : Subfield ℝ), ∃ (f : ℚ →+* ℝ), Function.Injective f ∧ S = f.fieldRange ∧ Monotone f := by
  refine ⟨(algebraMap ℚ ℝ).fieldRange, algebraMap ℚ ℝ, Rat.cast_injective, rfl, ?_⟩
  intro x y h
  exact Rat.cast_le.2 h