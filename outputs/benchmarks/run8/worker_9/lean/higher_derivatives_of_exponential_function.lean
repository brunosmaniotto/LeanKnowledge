import Mathlib

theorem Higher_Derivatives_of_Exponential_Function (n : ℕ) :
  iteratedDeriv n Real.exp = Real.exp := by
  induction n with
  | zero =>
    simp
  | succ k ih =>
    rw [iteratedDeriv_succ', Real.deriv_exp]
    exact ih