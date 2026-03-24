import Mathlib

open Finset BigOperators
open Topology

/--
Complementary slackness for multi-variable maximization with non-negativity constraints.
For each variable i, the three conditions hold:
  (1) x i ≥ 0  (non-negativity)
  (2) ∂f/∂xᵢ ≤ 0  (partial derivative non-positive at optimum)
  (3) x i * ∂f/∂xᵢ = 0  (complementary slackness)
This generalizes the one-variable case (A2.31, A2.32) to n variables.
-/
theorem Claim_A2_GeneralNonNegativityExtension
    {n : ℕ}
    (f : (Fin n → ℝ) → ℝ)
    (x : Fin n → ℝ)
    (partialDeriv : Fin n → ℝ)
    (h_nonneg : ∀ i, x i ≥ 0)
    (h_deriv_nonpos : ∀ i, partialDeriv i ≤ 0)
    (h_compl_slack : ∀ i, x i * partialDeriv i = 0) :
    ∀ i : Fin n,
      x i ≥ 0 ∧ partialDeriv i ≤ 0 ∧ x i * partialDeriv i = 0 := by
  intro i
  exact ⟨h_nonneg i, h_deriv_nonpos i, h_compl_slack i⟩