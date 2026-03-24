import Mathlib
open Topology

theorem claim_A1_4_2_e :
    ∀ (f : ℝ → ℝ) (x₁ x₂ : ℝ) (t : ℝ),
      0 ≤ t → t ≤ 1 →
      f (t * x₁ + (1 - t) * x₂) = t * f x₁ + (1 - t) * f x₂ →
      f (t * x₁ + (1 - t) * x₂) ≥ t * f x₁ + (1 - t) * f x₂ := by
  intro f x₁ x₂ t _ _ h
  linarith