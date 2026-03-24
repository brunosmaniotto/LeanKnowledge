import Mathlib

open scoped BigOperators
open Topology
open BigOperators

theorem Claim_5F_e
    {L : ℕ}
    (f : (Fin L → ℝ) → ℝ)
    (z_bar : Fin L → ℝ)
    (grad_f : Fin L → ℝ)
    (hconcave : ∀ z : Fin L → ℝ,
      f z ≤ f z_bar + ∑ i : Fin L, grad_f i * (z i - z_bar i))
    (hgrad_pos : ∀ i : Fin L, 0 < grad_f i) :
    ∀ z : Fin L → ℝ,
      f z - ∑ i : Fin L, grad_f i * z i ≤
      f z_bar - ∑ i : Fin L, grad_f i * z_bar i := by
  intro z
  have h := hconcave z
  have key : ∑ i : Fin L, grad_f i * (z i - z_bar i) =
    ∑ i : Fin L, grad_f i * z i - ∑ i : Fin L, grad_f i * z_bar i := by
    simp_rw [mul_sub]
    rw [← Finset.sum_sub_distrib]
  linarith