import Mathlib

open Set

theorem Claim_6C_u
    (r_A : ℝ → ℝ)
    (r_R : ℝ → ℝ)
    (h_rel : ∀ x : ℝ, 0 < x → r_R x = x * r_A x)
    (h_nonneg : ∀ x : ℝ, 0 < x → 0 ≤ r_A x)
    (h_decr_R : StrictAntiOn r_R (Ioi 0)) :
    StrictAntiOn r_A (Ioi 0) := by
  intro a ha b hb hab
  simp only [mem_Ioi] at ha hb
  have haR := h_rel a ha
  have hbR := h_rel b hb
  have hRab := h_decr_R (mem_Ioi.mpr ha) (mem_Ioi.mpr hb) hab
  rw [haR, hbR] at hRab
  -- hRab : b * r_A b < a * r_A a
  -- Need: r_A b < r_A a
  by_contra h_not
  push_neg at h_not
  -- h_not : r_A a ≤ r_A b
  have h1 : a * r_A a ≤ a * r_A b := by
    exact mul_le_mul_of_nonneg_left h_not (le_of_lt ha)
  have h2 : a * r_A b ≤ b * r_A b := by
    exact mul_le_mul_of_nonneg_right (le_of_lt hab) (h_nonneg b hb)
  linarith