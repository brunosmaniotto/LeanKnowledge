import Mathlib

variable {S : Type _}

/-- A relation `R` is one-to-many if for each `y`, there is at most one `x` such that `(x, y) ∈ R`. -/
def one_to_many (R : Set (S × S)) : Prop :=
  ∀ (y : S) (x₁ x₂ : S), (x₁, y) ∈ R → (x₂, y) ∈ R → x₁ = x₂