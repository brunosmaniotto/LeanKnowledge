import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- Complete formal specification of an extensive form game
    Γ_E = {X, A, I, p(·), α(·), H, H(·), ι(·), ρ(·), u}. -/
structure ExtensiveFormGameFull (Node Action : Type*) (numPlayers : ℕ)
    [Fintype Node] [DecidableEq Node] [Fintype Action] [DecidableEq Action] where
  root : Node
  pred : Node → Option Node
  actionOf : Node → Option Action
  infoSetOf : Node → ℕ
  playerOfInfoSet : ℕ → Fin (numPlayers + 1)
  natureProb : ℕ → Action → ℝ
  utility : Fin numPlayers → Node → ℝ
  root_no_pred : pred root = none
  nonroot_has_pred : ∀ x, x ≠ root → (pred x).isSome = true
  root_no_action : actionOf root = none
  nonroot_has_action : ∀ x, x ≠ root → (actionOf x).isSome = true
  sibling_actions_distinct : ∀ x y₁ y₂,
    pred y₁ = some x → pred y₂ = some x → actionOf y₁ = actionOf y₂ → y₁ = y₂
  infoSet_same_choices : ∀ x₁ x₂,
    infoSetOf x₁ = infoSetOf x₂ →
    {a | ∃ y, pred y = some x₁ ∧ actionOf y = some a} =
    {a | ∃ y, pred y = some x₂ ∧ actionOf y = some a}
  nature_nonneg : ∀ h a, 0 ≤ natureProb h a
  nature_sums_to_one : ∀ h,
    (∃ x, infoSetOf x = h ∧ playerOfInfoSet h = 0) →
    ∑ a : Action, natureProb h a = 1
  nature_zero_outside : ∀ h a,
    (¬∃ x y, infoSetOf x = h ∧ pred y = some x ∧ actionOf y = some a) →
    natureProb h a = 0