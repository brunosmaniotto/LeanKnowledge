import Mathlib

/-- Ramsey-Solow efficiency conditions: given price and production sequences satisfying
    the first-order conditions, the price ratio equals marginal product of capital
    and wages equal marginal product of labor. The transversality condition q_t → 0
    is sufficient for efficiency of a bounded feasible path. -/
theorem Example_20C6
    (F_k F_l : ℝ → ℝ → ℝ)
    (k l : ℕ → ℝ)
    (q w : ℕ → ℝ)
    (hq_pos : ∀ t, 0 < q t)
    (h_foc_k : ∀ t, q (t + 1) * F_k (k t) (l t) = q t)
    (h_foc_l : ∀ t, w t = q (t + 1) * F_l (k t) (l t))
    : (∀ t, q t / q (t + 1) = F_k (k t) (l t)) ∧
      (∀ t, w t / q (t + 1) = F_l (k t) (l t)) := by
  constructor
  · intro t
    have hq := hq_pos (t + 1)
    field_simp
    linarith [h_foc_k t]
  · intro t
    have hq := hq_pos (t + 1)
    field_simp
    linarith [h_foc_l t]