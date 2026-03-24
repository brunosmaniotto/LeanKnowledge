import Mathlib
open Topology

theorem Claim_3_5_d
    {n : ℕ}
    (p : ℝ) (hp : p > 0)
    (w : Fin n → ℝ) (Df : Fin n → ℝ)
    (hw : ∀ k, w k > 0)
    (hfoc : ∀ k, p * Df k = w k)
    (i j : Fin n) :
    Df i / Df j = w i / w j := by
  have hi := hfoc i
  have hj := hfoc j
  have hwj : w j > 0 := hw j
  have hDfj : Df j ≠ 0 := by
    intro h; rw [h, mul_zero] at hj; linarith
  rw [div_eq_div_iff hDfj (ne_of_gt hwj)]
  linear_combination Df j * hi - Df i * hj