import Mathlib

theorem congruence_of_sum_with_constant (a b z : ℝ) (h : a ≡ b [PMOD z]) (c : ℝ) : a + c ≡ b + c [PMOD z] :=
  h.add_right c