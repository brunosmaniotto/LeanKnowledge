import Mathlib

theorem abs_divisor_le (c : ℤ) (hc : c ≠ 0) (a : ℤ) (h : a ∣ c) : a ≤ |a| ∧ |a| ≤ |c| := by
  constructor
  · by_cases h0 : 0 ≤ a
    · rw [abs_of_nonneg h0]
    · rw [abs_of_neg (not_le.mp h0)]
      have : a ≤ 0 := by linarith
      linarith
  · have hpos : 0 < |c| := abs_pos.mpr hc
    have h_abs : |a| ∣ |c| := by
      rcases h with ⟨k, rfl⟩
      rw [abs_mul]
      exact dvd_mul_right _ _
    exact Int.le_of_dvd hpos h_abs