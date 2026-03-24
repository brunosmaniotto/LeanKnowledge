import Mathlib

open BigOperators Finset
open Topology

/-- Hotelling-Wold identity: given FOC ∂u/∂xᵢ = lam·pᵢ from the dual Lagrangian
    and budget constraint p·x = 1, the inverse demand is
    pᵢ(x) = (∂u/∂xᵢ) / (Σⱼ xⱼ · ∂u/∂xⱼ). -/
theorem Theorem_2_4
    {n : ℕ}
    (p x du : Fin n → ℝ)
    (lam : ℝ)
    (hlam_pos : lam > 0)
    (hFOC : ∀ j, du j = lam * p j)
    (hbudget : ∑ j : Fin n, p j * x j = 1)
    (i : Fin n) :
    p i = du i / (∑ j : Fin n, x j * du j) := by
  have hne : lam ≠ 0 := ne_of_gt hlam_pos
  have hsum : ∑ j : Fin n, x j * du j = lam := by
    simp_rw [hFOC]
    have : ∑ j : Fin n, x j * (lam * p j) = lam * ∑ j : Fin n, p j * x j := by
      rw [Finset.mul_sum]
      exact Finset.sum_congr rfl (fun j _ => by ring)
    rw [this, hbudget, mul_one]
  have hsum_ne : (∑ j : Fin n, x j * du j) ≠ 0 := by rw [hsum]; exact hne
  rw [eq_div_iff hsum_ne, hsum, mul_comm]
  exact (hFOC i).symm