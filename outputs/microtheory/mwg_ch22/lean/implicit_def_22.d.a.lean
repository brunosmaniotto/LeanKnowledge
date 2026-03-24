import Mathlib

/-- A social welfare functional F is invariant to common ordinal transformations if
    F(ū₁, …, ūᵢ) = F(ū'₁, …, ū'ᵢ) whenever there exists a strictly increasing function ψ
    such that ū'ᵢ(x) = ψ(ūᵢ(x)) for every alternative x and every individual i. -/
def InvariantToCommonOrdinalTransformations
    {X : Type*} {I : Type*} {R : Type*}
    (F : (I → X → ℝ) → R) : Prop :=
  ∀ (u u' : I → X → ℝ),
    (∃ ψ : ℝ → ℝ, StrictMono ψ ∧ ∀ (i : I) (x : X), u' i x = ψ (u i x)) →
    F u = F u'