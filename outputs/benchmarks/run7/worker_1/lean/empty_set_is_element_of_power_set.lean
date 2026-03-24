import Mathlib

theorem empty_set_mem_powerset {α : Type _} (S : Set α) : ∅ ∈ 𝒫 S :=
  Set.empty_subset S