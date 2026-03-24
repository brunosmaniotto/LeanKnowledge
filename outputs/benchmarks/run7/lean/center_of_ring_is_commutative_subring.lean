import Mathlib

-- center_is_subring
lemma center_is_subring (R : Type*) [Ring R] : Subring.center R ≤ (⊤ : Subring R) := by
  exact le_top

-- center_elements_commute