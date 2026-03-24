import Mathlib

theorem pow_modEq_of_modEq {a b m : ℤ} (h : a ≡ b [ZMOD m]) (n : ℕ) : a ^ n ≡ b ^ n [ZMOD m] := by
  induction n with
  | zero =>
      simp only [pow_zero]
      exact Int.ModEq.refl 1
  | succ k IH =>
      rw [pow_succ, pow_succ]
      exact IH.mul h