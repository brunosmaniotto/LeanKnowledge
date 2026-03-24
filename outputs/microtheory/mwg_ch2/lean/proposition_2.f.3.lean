import Mathlib

open BigOperators Finset

theorem Proposition_2_F_3
    {L : ℕ}
    (p x : Fin L → ℝ)
    (w : ℝ)
    (Dp_x : Fin L → Fin L → ℝ)
    (Dw_x : Fin L → ℝ)
    (cournot : ∀ k : Fin L, ∑ l, p l * Dp_x l k + x k = 0)
    (engel : ∑ l, p l * Dw_x l = 1)
    (euler : ∀ l : Fin L, ∑ k, Dp_x l k * p k + Dw_x l * w = 0)
    (walras : ∑ k, p k * x k = w) :
    (∀ k : Fin L, ∑ l, p l * (Dp_x l k + Dw_x l * x k) = 0) ∧
    (∀ l : Fin L, ∑ k, (Dp_x l k + Dw_x l * x k) * p k = 0) := by
  constructor
  · intro k
    have expand : ∑ l, p l * (Dp_x l k + Dw_x l * x k) =
                  (∑ l, p l * Dp_x l k) + (∑ l, p l * Dw_x l) * x k := by
      simp only [mul_add, Finset.sum_add_distrib]
      congr 1
      rw [Finset.sum_mul]
      congr 1; ext l; ring
    rw [expand, engel, one_mul]
    exact cournot k
  · intro l
    have expand : ∑ k, (Dp_x l k + Dw_x l * x k) * p k =
                  (∑ k, Dp_x l k * p k) + Dw_x l * (∑ k, x k * p k) := by
      simp only [add_mul, Finset.sum_add_distrib]
      congr 1
      rw [Finset.mul_sum]
      congr 1; ext k; ring
    have walras' : ∑ k, x k * p k = w := by
      have : ∑ k, x k * p k = ∑ k, p k * x k := by
        congr 1; ext k; ring
      linarith
    rw [expand, walras']
    linarith [euler l]