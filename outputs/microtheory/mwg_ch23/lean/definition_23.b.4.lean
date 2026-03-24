import Mathlib
open Topology

/-- A mechanism consists of strategy sets and an outcome function. -/
structure Mechanism (I : Type*) (S : I → Type*) (X : Type*) where
  outcome : (∀ i, S i) → X

/-- A mechanism Γ implements a social choice function f (with respect to a given
    equilibrium concept) if there exists an equilibrium strategy profile
    (s₁*(·),...,s_I*(·)) such that g(s*(θ)) = f(θ) for all type profiles θ. -/
def Mechanism.implements
    {I : Type*} {S : I → Type*} {Θ : I → Type*} {X : Type*}
    (Γ : Mechanism I S X)
    (f : (∀ i, Θ i) → X)
    (is_equilibrium : (∀ i, Θ i → S i) → (∀ i, Θ i) → Prop) : Prop :=
  ∃ s : ∀ i, Θ i → S i,
    (∀ θ, is_equilibrium s θ) ∧
    (∀ θ, Γ.outcome (fun i => s i (θ i)) = f θ)