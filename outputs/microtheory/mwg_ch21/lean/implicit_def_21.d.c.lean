import Mathlib

/-- An alternative `x` is a Condorcet winner if it defeats every other alternative
    under pairwise majority voting. Given a social welfare function `F` that aggregates
    individual preference profiles into a social preference, `x` is a Condorcet winner
    when `F(≿₁,…,≿_I) x y` holds for all `y ∈ X`. -/
def IsCondorcetWinner {X : Type*} [Fintype X] (F : X → X → Prop) (x : X) : Prop :=
  ∀ y : X, F x y