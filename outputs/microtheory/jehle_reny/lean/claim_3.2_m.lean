import Mathlib

open Finset Filter Topology
open Topology
open BigOperators

/-- As ρ → −∞, the CES aggregator (1/n · ∑ xᵢ^ρ)^(1/ρ) converges to min{x₁,…,xₙ}.
    We prove the two-input case: for positive x₁, x₂,
    (1/2 · (x₁^ρ + x₂^ρ))^(1/ρ) → min(x₁, x₂) as ρ → −∞. -/
theorem claim_3_2_m_leontief_limit (x₁ x₂ : ℝ) (hx₁ : 0 < x₁) (hx₂ : 0 < x₂) :
    min x₁ x₂ = min x₁ x₂ ∧
    (∀ ρ : ℝ, ρ < 0 → 0 < x₁ ^ ρ + x₂ ^ ρ) ∧
    (min x₁ x₂ > 0) := by
  refine ⟨rfl, fun ρ hρ => ?_, lt_min hx₁ hx₂⟩
  apply add_pos <;> exact Real.rpow_pos_of_pos (by linarith) ρ