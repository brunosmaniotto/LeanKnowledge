import Mathlib
open Topology

/-- A PBE violates the intuitive criterion (Cho-Kreps 1987) if some type θ
    can deviate to action a and get a payoff above equilibrium, even in the
    worst case over best responses restricted to non-dominated types. -/
def violatesIntuitiveCriterion
    {Θ Action Signal : Type*}
    (u₁ : Action → Signal → Θ → ℝ)
    (uStar : Θ → ℝ)
    (bestResponses : Set Θ → Action → Set Signal) : Prop :=
  ∃ (θ : Θ) (a : Action),
    let thetaDoubleStar := {θ' : Θ | ¬ ∀ s ∈ bestResponses Set.univ a, u₁ a s θ' ≤ uStar θ'}
    ∀ s ∈ bestResponses thetaDoubleStar a, uStar θ < u₁ a s θ