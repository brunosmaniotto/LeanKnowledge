import Mathlib

open Set

theorem exists_initial_segment (S T : Ordinal) (h : T < S) : ∃ a < S, Set.Iio T = Set.Iio a :=
  ⟨T, h, rfl⟩