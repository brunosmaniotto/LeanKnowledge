import Mathlib

theorem even_iff_sq_even (p : ℤ) : Even p ↔ Even (p ^ 2) := by
  rw [Int.even_pow]
  exact ⟨fun h => ⟨h, by norm_num⟩, fun h => h.1⟩