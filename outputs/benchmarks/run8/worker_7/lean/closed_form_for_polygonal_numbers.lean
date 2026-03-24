import Mathlib

noncomputable def P (k : ℤ) : ℕ → ℤ
  | 0 => 0
  | n + 1 => P k n + (k - 2) * (n : ℤ) + 1

theorem closed_form_mul (k : ℤ) (n : ℕ) : 2 * P k n = (n : ℤ) * ((k - 2) * (n : ℤ) - k + 4) := by
  induction' n with m IH
  · simp [P]
  · unfold P
    rw [mul_add, mul_add]
    rw [IH]
    push_cast
    ring