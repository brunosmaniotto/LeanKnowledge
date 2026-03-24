import Mathlib

theorem nonneg_iff_exists_nat (m : ℤ) : 0 ≤ m ↔ ∃ n : ℕ, m = n := by
  constructor
  · exact Int.eq_ofNat_of_zero_le
  · rintro ⟨n, rfl⟩
    simp