import Mathlib
open Topology

/-- A direct revelation mechanism for a social choice function.
In a direct revelation mechanism, each agent's strategy space is their type space,
and the outcome function equals the social choice function. -/
structure DirectRevelationMechanism
    {I : Type*} [Fintype I]
    (Θ : I → Type*)
    (X : Type*)
    (f : (∀ i, Θ i) → X) where
  /-- The mechanism's outcome function, which in a direct revelation mechanism
      takes reported types and produces an outcome -/
  g : (∀ i, Θ i) → X
  /-- The outcome function equals the social choice function for all type profiles -/
  g_eq_f : ∀ θ, g θ = f θ