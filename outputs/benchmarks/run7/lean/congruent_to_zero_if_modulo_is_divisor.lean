import Mathlib

noncomputable def Real.ModEq (a b : ℝ) (z : ℝ) : Prop :=
  ∃ k : ℤ, (k : ℝ) * z = a - b

notation:50 a " ≡ " b " [MOD " z "]" => Real.ModEq a b z

theorem real_mod_eq_zero_iff (a z : ℝ) : a ≡ 0 [MOD z] ↔ ∃ k : ℤ, (k : ℝ) * z = a := by
  simp [Real.ModEq, sub_zero]