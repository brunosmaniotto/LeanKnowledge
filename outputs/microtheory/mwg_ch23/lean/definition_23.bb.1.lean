import Mathlib
open Topology

-- A mechanism in the complete information setting
structure Mechanism (I : Type*) (S : I → Type*) (X : Type*) where
  outcome : (∀ i, S i) → X

-- Nash equilibrium: no agent can unilaterally deviate and improve
def IsNashEquilibrium {I : Type*} [DecidableEq I] {S : I → Type*} {X : Type*}
    (u : I → X → ℝ) (m : Mechanism I S X) (s : ∀ i, S i) : Prop :=
  ∀ i : I, ∀ si' : S i, u i (m.outcome s) ≥ u i (m.outcome (Function.update s i si'))

-- Implements f in Nash equilibrium:
-- for each θ, there exists a Nash equilibrium s*(θ) with g(s*(θ)) = f(θ)