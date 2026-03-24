import Mathlib

/-- A social choice function is ex post efficient if for every type profile,
    the selected alternative is Pareto optimal given the agents' utilities. -/
def ExPostEfficient
    {I : Type*} {X : Type*} {Θ : I → Type*}
    (u : (i : I) → X → Θ i → ℝ)
    (f : ((i : I) → Θ i) → X) : Prop :=
  ∀ (θ : (i : I) → Θ i),
    ¬∃ (y : X), (∀ i, u i y (θ i) ≥ u i (f θ) (θ i)) ∧ (∃ i, u i y (θ i) > u i (f θ) (θ i))