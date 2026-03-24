import Mathlib
open Topology

/-- A social choice function `f` is dictatorial on a subset `X̄ ⊂ X` if there exists
an agent `i` such that for every type profile `θ`, `f(θ)` maximizes agent `i`'s
utility over `X̄`. -/
def IsDictatorialOnSet
    {I : Type*} {X : Type*} {Θ : I → Type*}
    (Xbar : Set X)
    (u : (i : I) → X → Θ i → ℝ)
    (f : ((i : I) → Θ i) → X) : Prop :=
  ∃ i : I, ∀ θ : (j : I) → Θ j,
    f θ ∈ Xbar ∧
    ∀ y ∈ Xbar, u i (f θ) (θ i) ≥ u i y (θ i)