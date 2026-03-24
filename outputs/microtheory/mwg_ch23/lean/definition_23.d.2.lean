import Mathlib
open BigOperators

universe u

variable {I : Type*} [Fintype I] [DecidableEq I]

structure Mechanism (I : Type*) [Fintype I] (Θᵢ : I → Type*) (X : Type*) where
  S : I → Type*
  g : (∀ i, S i) → X

noncomputable def expectedUtility
    {I : Type*} [Fintype I] [DecidableEq I]
    {Θᵢ : I → Type*} [∀ i, Fintype (Θᵢ i)]
    {X : Type*}
    (mech : Mechanism I Θᵢ X)
    (prob : (∀ i, Θᵢ i) → ℝ)
    (utility : I → X → (∀ i, Θᵢ i) → ℝ)
    (σ : ∀ i, Θᵢ i → mech.S i)
    (i : I) (θᵢ : Θᵢ i) : ℝ :=
  ∑ θ : (∀ j, Θᵢ j),
    prob θ * utility i (mech.g (fun j => σ j (θ j))) θ

def IsBayesianNashEquilibrium
    {I : Type*} [Fintype I] [DecidableEq I]
    {Θᵢ : I → Type*} [∀ i, Fintype (Θᵢ i)]
    {X : Type*}
    (mech : Mechanism I Θᵢ X)
    (prob : (∀ i, Θᵢ i) → ℝ)
    (utility : I → X → (∀ i, Θᵢ i) → ℝ)
    (σ : ∀ i, Θᵢ i → mech.S i) : Prop :=
  ∀ (i : I) (θᵢ : Θᵢ i) (sᵢ' : Θᵢ i → mech.S i),
    expectedUtility mech prob utility σ i θᵢ ≥
    expectedUtility mech prob utility (Function.update σ i sᵢ') i θᵢ