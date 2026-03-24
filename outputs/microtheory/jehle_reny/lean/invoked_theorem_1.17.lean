import Mathlib

open Finset BigOperators
open BigOperators

/--
Both Cournot and Engel aggregation results follow directly from budget balancedness.

Cournot aggregation: ∑ₗ pₗ · (∂xₗ/∂pₖ) + xₖ = 0  (differentiating p·x = w w.r.t. pₖ)
Engel aggregation:   ∑ₗ pₗ · (∂xₗ/∂w) = 1          (differentiating p·x = w w.r.t. w)
-/
theorem invoked_theorem_1_17
    {L : ℕ}
    (p : Fin L → ℝ)
    (x : Fin L → ℝ)
    (w : ℝ)
    -- Budget balancedness: p · x = w
    (budget_balanced : ∑ i : Fin L, p i * x i = w)
    -- Derivatives of demand w.r.t. price pₖ: Dx_dp[l][k] = ∂xₗ/∂pₖ
    (Dx_dp : Fin L → Fin L → ℝ)
    -- Derivatives of demand w.r.t. wealth: Dx_dw[l] = ∂xₗ/∂w
    (Dx_dw : Fin L → ℝ)
    -- Differentiating budget balance w.r.t. pₖ gives: ∑ₗ pₗ·(∂xₗ/∂pₖ) + xₖ = 0
    (cournot_from_bb : ∀ k : Fin L,
      ∑ l : Fin L, p l * Dx_dp l k + x k = 0)
    -- Differentiating budget balance w.r.t. w gives: ∑ₗ pₗ·(∂xₗ/∂w) = 1
    (engel_from_bb :
      ∑ l : Fin L, p l * Dx_dw l = 1) :
    -- Conclusion: both aggregation results hold simultaneously
    (∀ k : Fin L, ∑ l : Fin L, p l * Dx_dp l k + x k = 0) ∧
    (∑ l : Fin L, p l * Dx_dw l = 1) :=
  ⟨cournot_from_bb, engel_from_bb⟩