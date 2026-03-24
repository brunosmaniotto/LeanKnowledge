import Mathlib
open Topology

variable {I X Θ : Type*} [Fintype I] [Fintype X] [Nonempty X]

/-- A type profile is a function from agents to their types. -/
abbrev TypeProfile (I Θ : Type*) := I → Θ

/-- Definition 23.C.4: A social choice function f is dictatorial if there exists an agent i
    such that for every type profile, f always selects one of agent i's top-ranked alternatives. -/
def IsDictatorial
    (u : I → X → Θ → ℝ)
    (f : TypeProfile I Θ → X) : Prop :=
  ∃ i : I, ∀ θ : TypeProfile I Θ, ∀ y : X, u i (f θ) (θ i) ≥ u i y (θ i)