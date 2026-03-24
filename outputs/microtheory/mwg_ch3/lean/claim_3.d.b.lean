import Mathlib
open Topology

theorem mrs_equals_price_ratio
    {n : ℕ} (grad_u p : Fin n → ℝ) (lam : ℝ)
    (hlam_pos : 0 < lam)
    (hfoc : ∀ i, grad_u i = lam * p i)
    (hgrad_pos : ∀ i, 0 < grad_u i)
    (l k : Fin n) :
    grad_u l / grad_u k = p l / p k := by
  have hk_pos : 0 < grad_u k := hgrad_pos k
  rw [hfoc l, hfoc k]
  rw [mul_div_mul_left _ _ (ne_of_gt hlam_pos)]