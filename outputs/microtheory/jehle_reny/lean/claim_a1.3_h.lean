import Mathlib
open Topology

variable {X : Type*} [TopologicalSpace X] (S : Set X)

theorem claim_A1_3_h :
    (IsOpen S ↔ S = interior S) ∧
    (IsClosed S ↔ S = interior S ∪ frontier S) := by
  constructor
  · constructor
    · intro h
      exact (IsOpen.interior_eq h).symm
    · intro h
      rw [h]
      exact isOpen_interior
  · constructor
    · intro h
      rw [frontier, Set.union_diff_cancel interior_subset_closure]
      exact (IsClosed.closure_eq h).symm
    · intro h
      rw [← closure_eq_iff_isClosed]
      rw [h, frontier, Set.union_diff_cancel interior_subset_closure]
      exact IsClosed.closure_eq isClosed_closure