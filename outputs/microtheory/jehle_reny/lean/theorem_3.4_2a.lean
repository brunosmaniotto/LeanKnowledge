import Mathlib

open Real

noncomputable section

theorem Theorem_3_4_2a
    (α : ℝ) (hα : 0 < α)
    (c : ℝ → ℝ → ℝ)
    (h_homog : ∀ (w t y : ℝ), 0 < t → c w (t * y) = t ^ (1 / α) * c w y) :
    ∀ (w y : ℝ), 0 < y → c w y = y ^ (1 / α) * c w 1 := by
  intro w y hy
  have := h_homog w y 1 hy
  simp only [mul_one] at this
  exact this