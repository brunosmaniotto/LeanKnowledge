import Mathlib
open Topology

/-- A social welfare functional F is utility-level invariant (invariant to common ordinal
    transformations) if applying any common strictly increasing transformation ψ : ℝ → ℝ
    to every individual's utility function does not change the social outcome.
    That is, F depends only on the ordering of utilities across individuals. -/
def UtilityLevelInvariant
    {X : Type*} {ι : Type*} {R : Type*}
    (F : (ι → X → ℝ) → R) : Prop :=
  ∀ (u : ι → X → ℝ) (ψ : ℝ → ℝ), StrictMono ψ →
    F (fun i x => ψ (u i x)) = F u