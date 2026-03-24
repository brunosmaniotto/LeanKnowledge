import Mathlib

theorem cyclic_is_abelian (G : Type*) [Group G] [IsCyclic G] (a b : G) : a * b = b * a := by
  letI : CommGroup G := IsCyclic.commGroup
  exact mul_comm a b