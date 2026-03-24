import Mathlib

open Set

theorem intersection_with_complement (S : Set α) : S ∩ Sᶜ = ∅ :=
  Set.inter_compl_self S