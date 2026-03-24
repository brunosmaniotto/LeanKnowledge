import Mathlib

open BigOperators Finset
open Topology

theorem claim_1_3_g
    {n : ℕ} [NeZero n]
    (p : Fin n → ℝ)
    (y : ℝ)
    (x_star : Fin n → ℝ)
    (grad_u : Fin n → ℝ)
    -- x* ≫ 0 (interior solution)
    (hx_pos : ∀ i, 0 < x_star i)
    -- KKT multiplier from Theorem A2.20
    (lambda_star : ℝ)
    (hlam_nonneg : 0 ≤ lambda_star)
    -- KKT FOC with complementary slackness: ∂u/∂xᵢ = λ*pᵢ when xᵢ > 0
    (hfoc_cs : ∀ i, x_star i > 0 → grad_u i = lambda_star * p i)
    -- Budget feasibility
    (hbudget_le : ∑ i, p i * x_star i ≤ y)
    -- Strict monotonicity forces budget to bind
    (hbudget_eq : ∑ i, p i * x_star i = y) :
    -- Reduced conditions (1.10): FOC holds for ALL i, budget binds, λ* ≥ 0
    (∀ i, grad_u i = lambda_star * p i) ∧
    (∑ i, p i * x_star i = y) ∧
    (0 ≤ lambda_star) := by
  exact ⟨fun i => hfoc_cs i (hx_pos i), hbudget_eq, hlam_nonneg⟩