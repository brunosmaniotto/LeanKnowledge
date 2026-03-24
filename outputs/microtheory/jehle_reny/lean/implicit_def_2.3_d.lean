import Mathlib

/-- A utility function `u : X → ℝ` **rationalises** a choice rule `C` over a family
    of budget sets `ℬ` if, for every budget set `B ∈ ℬ`, the set of chosen
    elements `C(B)` is exactly the set of utility maximisers in `B`. -/
def Rationalizes {X : Type*} (u : X → ℝ) (C : Set X → Set X) (ℬ : Set (Set X)) : Prop :=
  ∀ B ∈ ℬ, C B = {x ∈ B | ∀ y ∈ B, u y ≤ u x}