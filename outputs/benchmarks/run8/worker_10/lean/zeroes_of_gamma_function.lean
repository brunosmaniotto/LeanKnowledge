import Mathlib

open Complex

theorem Zeroes_of_Gamma_Function (s : ℂ) (h : ∀ n : ℕ, s ≠ -n) : Gamma s ≠ 0 :=
  Gamma_ne_zero h