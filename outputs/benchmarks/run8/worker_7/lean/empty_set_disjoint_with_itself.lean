import Mathlib

theorem empty_inter_self {α : Type _} : (∅ : Set α) ∩ ∅ = ∅ :=
  Set.empty_inter ∅