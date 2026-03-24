import Mathlib

noncomputable section

open BigOperators

variable (L : ℕ)

theorem Proposition_4C4
    (x : (Fin L → ℝ) → ℝ → (Fin L → ℝ))
    (x_zero : ∀ (p : Fin L → ℝ), x p 0 = 0)
    (wbar : ℝ) (hwbar : 0 < wbar)
    (v : Fin L → ℝ) (p : Fin L → ℝ)
    -- The aggregate quadratic form decomposes into two terms
    (slutsky_term wealth_term aggregate_qf : ℝ)
    (h_slutsky : slutsky_term ≤ 0)
    (h_wealth : wealth_term = -(1 / (2 * wbar)) *
      (∑ i : Fin L, v i * (x p wbar) i) ^ 2)
    (h_decomp : aggregate_qf = slutsky_term + wealth_term)
    : aggregate_qf ≤ 0 := by
  have h_w_nonpos : wealth_term ≤ 0 := by
    rw [h_wealth]
    apply mul_nonpos_of_nonpos_of_nonneg
    · apply neg_nonpos_of_nonneg
      apply div_nonneg zero_le_one (by linarith)
    · exact sq_nonneg _
  linarith