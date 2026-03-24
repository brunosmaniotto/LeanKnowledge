import Mathlib

open Finset
open BigOperators

/-- The Borda score of alternative `x` under a preference relation `le`.
    The rank of `y` is 1 + the number of strictly preferred alternatives.
    For indifferent alternatives, the score is the average of their ranks. -/
noncomputable def bordaScore {X : Type*} [Fintype X] [DecidableEq X]
    (le : X → X → Prop) [DecidableRel le] (x : X) : ℚ :=
  let rank (y : X) : ℕ := (Finset.univ.filter (fun z => le z y ∧ ¬le y z)).card + 1
  let indiffClass := Finset.univ.filter (fun y => le x y ∧ le y x)
  (indiffClass.sum (fun y => (rank y : ℚ))) / indiffClass.card

/-- The Borda count social welfare functional. Given a profile of preferences,
    `x` is socially preferred to `y` iff the sum of Borda scores for `x`
    is at most the sum for `y`. -/
noncomputable def bordaCount {X : Type*} {I : Type*} [Fintype X] [DecidableEq X]
    [Fintype I] (prefs : I → X → X → Prop) [∀ i, DecidableRel (prefs i)]
    (x y : X) : Prop :=
  ∑ i : I, bordaScore (prefs i) x ≤ ∑ i : I, bordaScore (prefs i) y