import Mathlib
open Topology

/-- A direct mechanism is incentive-compatible if truthful reporting maximizes
    each individual's expected utility. For each individual i and each true type
    t_i, the expected utility u_i(r_i, t_i) is maximized at r_i = t_i. -/
def IsIncentiveCompatible
    {I : Type*} [Fintype I]
    (T : I → Type*)
    (u : (i : I) → T i → T i → ℝ) : Prop :=
  ∀ (i : I) (tᵢ : T i) (rᵢ : T i), u i tᵢ tᵢ ≥ u i rᵢ tᵢ