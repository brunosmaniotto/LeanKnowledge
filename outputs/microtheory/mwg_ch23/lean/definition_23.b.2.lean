import Mathlib

/-- A social choice function `f` is ex post efficient (Paretian) if there is no profile `θ`
    and alternative `x` such that every agent weakly prefers `x` to `f(θ)` and some agent
    strictly prefers `x` to `f(θ)`. -/
def ExPostEfficient
    {I : Type*} {X : Type*} {Θ : I → Type*}
    (u : (i : I) → X → Θ i → ℝ)
    (f : ((i : I) → Θ i) → X) : Prop :=
  ∀ (θ : (i : I) → Θ i), ¬∃ (x : X),
    (∀ i, u i x (θ i) ≥ u i (f θ) (θ i)) ∧
    (∃ i, u i x (θ i) > u i (f θ) (θ i))