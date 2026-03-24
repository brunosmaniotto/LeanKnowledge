import Mathlib
open Topology
open BigOperators

/-- A mechanism consists of strategy sets and an outcome function. -/
structure Mechanism (I : Type*) (S : I → Type*) (Outcome : Type*) where
  /-- The outcome function g : ∏ᵢ Sᵢ → Outcome -/
  g : (∀ i, S i) → Outcome

/-- A mechanism Γ implements a social choice function f in dominant strategies
    if there exists a dominant strategy equilibrium s*(·) such that
    g(s*(θ)) = f(θ) for all θ ∈ Θ. -/
structure ImplementsInDominantStrategies
    {I : Type*} [DecidableEq I] {S : I → Type*} {Outcome : Type*}
    (Γ : Mechanism I S Outcome)
    (θType : I → Type*)
    (uᵢ : (i : I) → Outcome → θType i → ℝ)
    (f : (∀ i, θType i) → Outcome) where
  /-- The strategy profile s* : ∀ i, θᵢ → Sᵢ -/
  sStar : ∀ i, θType i → S i
  /-- s* is a dominant strategy equilibrium: for each agent i and type θᵢ,
      s*ᵢ(θᵢ) is optimal regardless of others' strategies -/
  isDominant : ∀ (i : I) (θᵢ : θType i) (sᵢ' : S i) (s_others : ∀ j, S j),
    uᵢ i (Γ.g (Function.update s_others i (sStar i θᵢ))) (θᵢ) ≥
    uᵢ i (Γ.g (Function.update s_others i sᵢ')) (θᵢ)
  /-- g(s*(θ)) = f(θ) for all type profiles θ ∈ Θ -/
  implements : ∀ (θ : ∀ i, θType i),
    Γ.g (fun i => sStar i (θ i)) = f θ