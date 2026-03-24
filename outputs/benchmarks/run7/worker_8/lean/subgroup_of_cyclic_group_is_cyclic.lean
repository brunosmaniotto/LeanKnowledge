import Mathlib

theorem subgroup_of_cyclic_is_cyclic (G : Type*) [Group G] [IsCyclic G] (H : Subgroup G) : IsCyclic H := by
  infer_instance