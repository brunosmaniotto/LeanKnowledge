import Mathlib
open Topology

theorem mrs_equals_price_ratio_claim_1_3_i
    {n : ℕ} (grad_u p : Fin n → ℝ) (lam : ℝ)
    (hlam_pos : 0 < lam)
    (hfoc : ∀ i, grad_u i = lam * p i)
    (hgrad_pos : ∀ i, 0 < grad_u i)
    (j k : Fin n) :
    grad_u j / grad_u k = p j / p k := by
  rw [hfoc j, hfoc k]
  rw [mul_div_mul_left _ _ (ne_of_gt hlam_pos)]