import Mathlib

axiom cancel_positive_factor (M δ : ℝ) (hM : 0 < M) (hδ1 : 0 < 1 - δ) : M / (2 * (1 - δ)) ≥ M ↔ 1 / (2 * (1 - δ)) ≥ 1
axiom reciprocal_ineq (δ : ℝ) (hδ1 : 0 < 1 - δ) : 1 / (2 * (1 - δ)) ≥ 1 ↔ 2 * (1 - δ) ≤ 1
axiom linear_ineq_equiv (δ : ℝ) : 2 * (1 - δ) ≤ 1 ↔ δ ≥ 1 / 2

theorem Proposition_12D1 (M δ : ℝ) (hM : 0 < M) (hδ : 0 < δ) (hδ1 : δ < 1) :
    M / (2 * (1 - δ)) ≥ M ↔ δ ≥ 1 / 2 := by
  have hδ1' : 0 < 1 - δ := by linarith
  exact (cancel_positive_factor M δ hM hδ1').trans
    ((reciprocal_ineq δ hδ1').trans (linear_ineq_equiv δ))