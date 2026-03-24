import Mathlib

variable (S1 : Type u) (S2 : Type v) [Mul S1] [Mul S2]

theorem pr1_is_epimorphism [Nonempty S2] : Function.Surjective (MulHom.fst S1 S2) := by
  intro a
  exact ⟨(a, Classical.arbitrary S2), rfl⟩