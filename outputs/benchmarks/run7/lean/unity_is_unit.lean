import Mathlib

theorem unity_is_unit {R : Type} [Ring R] : IsUnit (1 : R) :=
  ⟨1, by simp⟩