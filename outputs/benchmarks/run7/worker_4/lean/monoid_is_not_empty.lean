import Mathlib

theorem monoid_nonempty (M : Type) [Monoid M] : Nonempty M :=
  ⟨1⟩