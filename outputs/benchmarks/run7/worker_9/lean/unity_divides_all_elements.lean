import Mathlib

variable (D : Type _) [CommRing D] [IsDomain D]

theorem unity_divides_all (x : D) : (1 : D) ∣ x := by
  exact ⟨x, by ring⟩