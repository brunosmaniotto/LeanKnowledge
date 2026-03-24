import Mathlib

theorem Congruence_of_Quotient (a b : ℤ) (n : ℕ) (d : ℤ)
    (h_d_pos : d > 0)
    (ha : d ∣ a)
    (hb : d ∣ b)
    (hn : d ∣ (n : ℤ))
    (h_cong : a ≡ b [ZMOD n]) :
    a / d ≡ b / d [ZMOD (n : ℤ) / d] := by
  rw [Int.modEq_iff_dvd] at h_cong ⊢
  have hd_ne_zero : d ≠ 0 := by linarith
  rw [← Int.mul_dvd_mul_iff_left hd_ne_zero]
  rw [Int.mul_ediv_cancel' hn]
  rw [mul_sub, Int.mul_ediv_cancel' hb, Int.mul_ediv_cancel' ha]
  exact h_cong