import Mathlib

variable {X : Type*}

/-- Given a choice structure (ℬ, C(·)), the revealed preference relation ≿*.
    `x ≿* y` iff there exists some budget set `B ∈ ℬ` with `x, y ∈ B` and `x ∈ C(B)`. -/
def RevealedWeakPref (ℬ : Set (Set X)) (C : Set X → Set X) (x y : X) : Prop :=
  ∃ B ∈ ℬ, x ∈ B ∧ y ∈ B ∧ x ∈ C B