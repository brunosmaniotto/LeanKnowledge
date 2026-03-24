import Mathlib

theorem card_le_of_subset {α : Type*} {A B : Set α} {n : ℕ}
    (hAB : A ⊆ B) (hA : Set.Finite A) (hB : Set.Finite B) (hBcard : Set.ncard B = n) :
    Set.ncard A ≤ n := by
  rw [← hBcard]
  exact Set.ncard_le_ncard hAB hB