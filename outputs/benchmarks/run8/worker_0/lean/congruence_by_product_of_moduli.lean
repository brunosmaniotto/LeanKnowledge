import Mathlib

theorem Congruence_by_Product_of_Moduli (a b m n : ℤ) (hn : n ≠ 0) : a ≡ b [ZMOD m] ↔ a * n ≡ b * n [ZMOD m * n] := by
  constructor
  · intro h
    rw [Int.modEq_iff_dvd] at h
    rw [Int.modEq_iff_dvd]
    rw [← sub_mul]
    exact mul_dvd_mul_right h n
  · intro h
    rw [Int.modEq_iff_dvd] at h
    rw [← sub_mul] at h
    rw [Int.modEq_iff_dvd]
    exact (Int.mul_dvd_mul_iff_right hn).mp h