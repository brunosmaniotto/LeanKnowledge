import Mathlib
open Topology

theorem Claim_4D_FOC
    (n : ℕ) (hn : 0 < n)
    (marginal_social_utility : Fin n → ℝ)
    (lam : ℝ) (hlam : 0 < lam)
    (hFOC : ∀ i : Fin n, marginal_social_utility i = lam) :
    ∀ i j : Fin n, marginal_social_utility i = marginal_social_utility j := by
  intro i j
  rw [hFOC i, hFOC j]