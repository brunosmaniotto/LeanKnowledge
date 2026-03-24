import Mathlib
open Topology

/-- A marginal product (no-surplus) allocation: each type's utility equals
    the marginal contribution of that type to the social value function. -/
structure NoSurplusAllocation
    (H : ℕ)
    (u : Fin H → (Fin H → ℝ) → ℝ)
    (v : (Fin H → ℝ) → ℝ)
    (μ : Fin H → ℝ)
    (x_star : Fin H → (Fin H → ℝ)) where
  /-- Population weights are nonneg -/
  pop_nonneg : ∀ h, 0 ≤ μ h
  /-- Each type's utility at her allocation equals the marginal product of her population mass -/
  no_surplus : ∀ h, u h (x_star h) = deriv (fun t => v (Function.update μ h t)) (μ h)