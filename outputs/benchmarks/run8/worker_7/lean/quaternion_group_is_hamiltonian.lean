import Mathlib

open QuaternionGroup
open Subgroup

/-- A Hamiltonian group is a non-abelian group where every subgroup is normal. -/
def IsHamiltonianGroup (G : Type*) [Group G] : Prop :=
  (∃ x y : G, x * y ≠ y * x) ∧ ∀ H : Subgroup G, H.Normal