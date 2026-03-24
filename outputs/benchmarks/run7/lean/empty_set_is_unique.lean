import Mathlib

/-- The empty set is unique. -/
theorem empty_set_unique (A B : Set α) (hA : ∀ x, x ∉ A) (hB : ∀ x, x ∉ B) : A = B := by
  ext x
  constructor
  · intro h
    exfalso
    exact hA x h
  · intro h
    exfalso
    exact hB x h