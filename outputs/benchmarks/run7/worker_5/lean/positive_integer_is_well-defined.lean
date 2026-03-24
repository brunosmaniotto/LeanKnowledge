import Mathlib

theorem positive_well_defined {a b c d : ℕ} (h_eq : a + d = b + c) (h_lt : b < a) : d < c := by
  omega