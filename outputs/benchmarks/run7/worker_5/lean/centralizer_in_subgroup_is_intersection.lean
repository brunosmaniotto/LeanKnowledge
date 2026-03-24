import Mathlib

open Set

theorem centralizer_in_subgroup_eq_intersection (G : Type _) [Group G] 
    (H : Subgroup G) (x : G) :
    {g ∈ H | g * x = x * g} = (Subgroup.centralizer ({x} : Set G) : Set G) ∩ (H : Set G) := by
  ext g
  simp [Subgroup.mem_centralizer_iff, and_comm, eq_comm]