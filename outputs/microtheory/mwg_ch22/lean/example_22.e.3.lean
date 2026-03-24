import Mathlib

open Finset BigOperators
open BigOperators

/-- The Nash bargaining solution for an I-player bargaining problem.
    Given a set U ⊆ ℝᴵ of feasible utility vectors, returns the point
    in U ∩ ℝᴵ₊ that maximizes the product u₁ × ⋯ × uᵢ,
    or equivalently maximizes Σᵢ ln(uᵢ). -/
noncomputable def nashBargainingSolution {I : Type*} [Fintype I]
    (U : Set (I → ℝ)) : I → ℝ :=
  Classical.epsilon fun u =>
    u ∈ U ∧ (∀ i, 0 < u i) ∧
    ∀ v ∈ U, (∀ i, 0 < v i) →
      ∑ i : I, Real.log (v i) ≤ ∑ i : I, Real.log (u i)