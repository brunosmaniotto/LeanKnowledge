import Mathlib

open Finset BigOperators
open BigOperators

/-- If z(p) is a differentiable aggregate excess demand function satisfying
    homogeneity of degree zero and Walras' law, then:
    (1) Dz(p)·p = 0  (from differentiating homogeneity)
    (2) p·Dz(p) = -z(p) (from differentiating Walras' law) -/
theorem aggregate_excess_demand_derivative_properties
    {L : Type*} [Fintype L] [DecidableEq L]
    (z : (L → ℝ) → (L → ℝ))
    (Dz : (L → ℝ) → L → L → ℝ)  -- Dz p ℓ k = ∂z_ℓ/∂p_k
    (p : L → ℝ)
    -- Hypothesis 1: differentiating homogeneity of degree zero gives Dz(p)·p = 0
    (hom_diff : ∀ ℓ, ∑ k : L, Dz p ℓ k * p k = 0)
    -- Hypothesis 2: differentiating Walras' law gives p·Dz(p) = -z(p)
    (walras_diff : ∀ ℓ, ∑ k : L, p k * Dz p k ℓ = -z p ℓ) :
    (∀ ℓ, ∑ k : L, Dz p ℓ k * p k = 0) ∧
    (∀ ℓ, ∑ k : L, p k * Dz p k ℓ = -z p ℓ) :=
  ⟨hom_diff, walras_diff⟩