import Mathlib

/-- An infinite cyclic group is isomorphic to the additive group of integers. -/
noncomputable def infinite_cyclic_group_isomorphic_to_integers
    (G : Type*) [Group G] [IsCyclic G] [Infinite G] : G ≃* Multiplicative ℤ :=
  intCyclicMulEquiv.symm