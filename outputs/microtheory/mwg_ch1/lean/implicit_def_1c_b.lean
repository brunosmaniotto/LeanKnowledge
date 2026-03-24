import Mathlib

/-- `RevealedPreferred ℬ C x y` holds when there exists some budget set `B ∈ ℬ`
    such that `x, y ∈ B`, `x ∈ C(B)`, and `y ∉ C(B)`. -/
def RevealedPreferred {α : Type*} (ℬ : Set (Set α)) (C : Set α → Set α) (x y : α) : Prop :=
  ∃ B ∈ ℬ, x ∈ B ∧ y ∈ B ∧ x ∈ C B ∧ y ∉ C B