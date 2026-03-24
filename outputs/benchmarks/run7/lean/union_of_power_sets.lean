import Mathlib

theorem union_powerset_subset_powerset_union (α : Type _) (S T : Set α) :
    Set.powerset S ∪ Set.powerset T ⊆ Set.powerset (S ∪ T) := by
  intro X hX
  rcases hX with (h | h)
  · intro x hx
    have hxS : x ∈ S := h hx
    exact Set.mem_union_left T hxS
  · intro x hx
    have hxT : x ∈ T := h hx
    exact Set.mem_union_right S hxT