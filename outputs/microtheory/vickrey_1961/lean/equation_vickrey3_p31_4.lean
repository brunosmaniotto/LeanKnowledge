import Mathlib

universe u

theorem Equation_Vickrey3_p31_4 {X : Type u}
  (a b : ℝ)
  (v2 y2 : X → ℝ)
  (h_linear : ∀ x : X, v2 x = (b - a) * y2 x + a)
  (h_ne : b ≠ a)
  : ∀ x : X, y2 x = (v2 x - a) / (b - a) := by
  intro x
  have h_ne' : b - a ≠ 0 := sub_ne_zero.mpr h_ne
  rw [eq_div_iff h_ne']
  rw [mul_comm]
  linarith [h_linear x]