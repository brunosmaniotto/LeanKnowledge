import Mathlib

/-- A social choice function `c` is dictatorial if there exists an individual `i`
    such that for every preference profile, the chosen alternative `c(R)` is
    weakly preferred by `i` to every other alternative. -/
def IsDictatorial {N X : Type*} [Fintype X]
    (c : (N → X → X → Prop) → X)
    (A : Set (N → X → X → Prop)) : Prop :=
  ∃ i : N, ∀ R ∈ A, ∀ y : X, R i (c R) y