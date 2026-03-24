import Mathlib

open Set Function
open Topology

/-- A complementarity structure for two-good Cournot competition. -/
structure CournotComplementarity where
  /-- Utility function ψ : ℝ × ℝ → ℝ -/
  ψ : ℝ → ℝ → ℝ
  /-- ψ(0, x₂) = 0 for all x₂ -/
  complement_left : ∀ x₂, ψ 0 x₂ = 0
  /-- ψ(x₁, 0) = 0 for all x₁ -/
  complement_right : ∀ x₁, ψ x₁ 0 = 0
  /-- Price function for good 1 given aggregate quantities -/
  p₁ : ℝ → ℝ → ℝ
  /-- Price equals partial derivative of ψ w.r.t. x₁ -/
  price_is_deriv : ∀ q₁ q₂, p₁ q₁ q₂ = deriv (fun x₁ => ψ x₁ q₂) q₁
  /-- ψ(·, 0) is differentiable (being identically zero) -/
  diff_at_zero : Differentiable ℝ (fun x₁ => ψ x₁ 0)

/-- When q₂ = 0, the price of good 1 is zero for any quantity,
    so null production is a trading equilibrium. -/
theorem Example_18C2 (C : CournotComplementarity) :
    ∀ q₁ : ℝ, C.p₁ q₁ 0 = 0 := by
  intro q₁
  rw [C.price_is_deriv]
  have h : (fun x₁ => C.ψ x₁ 0) = fun _ => 0 := by
    ext x₁
    exact C.complement_right x₁
  rw [h]
  simp [deriv_const]