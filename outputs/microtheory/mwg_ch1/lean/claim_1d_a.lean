import Mathlib

variable {X : Type*}

/-- If ≿ is a rational preference relation (total preorder) and B is a nonempty finite set,
    then the choice set C*(B, ≿) is nonempty: there exists an element weakly preferred to all others. -/
theorem choice_set_nonempty_of_finite
    [LinearOrder X]
    (B : Finset X) (hB : B.Nonempty) :
    ∃ x ∈ B, ∀ y ∈ B, y ≤ x := by
  exact ⟨B.max' hB, B.max'_mem hB, fun y hy => B.le_max' y hy⟩