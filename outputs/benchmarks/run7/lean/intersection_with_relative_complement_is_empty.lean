import Mathlib

theorem intersection_with_relative_complement {α : Type*} (S T : Set α) : T ∩ (S \ T) = ∅ :=
  Set.inter_diff_self T S