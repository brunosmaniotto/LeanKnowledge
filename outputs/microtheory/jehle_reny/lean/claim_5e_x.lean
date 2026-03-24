import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- Cobb-Douglas utility ∏ₖ xₖ^{αₖ} equals zero whenever any component xⱼ = 0.
    This shows Cobb-Douglas utility is not strongly increasing on ℝⁿ₊ (part a):
    increasing other coordinates from a boundary point does not raise utility from 0,
    so Theorem 5.5 does not apply. Since aggregate excess demand from Cobb-Douglas
    consumers still satisfies Walras' law, homogeneity of degree zero, and continuity,
    Theorem 5.3 guarantees Walrasian equilibrium existence (parts b and c). -/
theorem Claim_5e_x
    {n : ℕ}
    (α : Fin n → ℝ)
    (hα_pos : ∀ k, 0 < α k)
    (hα_sum : ∑ k, α k = 1)
    (x : Fin n → ℝ)
    (hx_nn : ∀ k, 0 ≤ x k)
    (j : Fin n) (hj : x j = 0) :
    ∏ k : Fin n, (x k) ^ (α k) = 0 := by
  apply Finset.prod_eq_zero (Finset.mem_univ j)
  rw [hj]
  exact Real.zero_rpow (hα_pos j).ne'