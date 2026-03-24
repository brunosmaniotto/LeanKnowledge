import Mathlib
open Topology
set_option linter.unusedVariables false

/-- A social welfare function is utility-level invariant if applying any common
    strictly increasing transformation ψ to every individual's utility leaves f unchanged. -/
noncomputable def UtilityLevelInvariant
    {X : Type*} {I : Type*} {R : Type*}
    (f : (I → X → ℝ) → R) : Prop :=
  ∀ (u : I → X → ℝ) (ψ : ℝ → ℝ), StrictMono ψ →
    f (fun i x => ψ (u i x)) = f u

/-- A social welfare function is utility-difference invariant if applying affine
    transformations ψᵢ(t) = aᵢ + b·t with a common b > 0 leaves f unchanged. -/
noncomputable def UtilityDifferenceInvariant
    {X : Type*} {I : Type*} {R : Type*}
    (f : (I → X → ℝ) → R) : Prop :=
  ∀ (u : I → X → ℝ) (a : I → ℝ) (b : ℝ), b > 0 →
    f (fun i x => a i + b * u i x) = f u