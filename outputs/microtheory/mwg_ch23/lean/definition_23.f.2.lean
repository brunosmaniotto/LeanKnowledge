import Mathlib

/-- A social choice function `f` is interim efficient in a set `F` of feasible social choice functions
    if there is no alternative in `F` that weakly dominates `f` for all agents and types, and strictly
    dominates for at least one agent-type pair. -/
def InterimEfficientInF
    {I : Type*} [Fintype I]
    {Theta : I → Type*} {Outcome : Type*}
    (U : (i : I) → Theta i → (((i : I) → Theta i) → Outcome) → ℝ)
    (F : Set (((i : I) → Theta i) → Outcome))
    (f : ((i : I) → Theta i) → Outcome) : Prop :=
  f ∈ F ∧
  ¬ ∃ g ∈ F,
    (∀ i, ∀ ti : Theta i, U i ti g ≥ U i ti f) ∧
    (∃ i, ∃ ti : Theta i, U i ti g > U i ti f)