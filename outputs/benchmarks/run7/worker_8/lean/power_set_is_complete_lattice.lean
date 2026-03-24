import Mathlib

/-- The power set of any type `S` forms a complete lattice under the subset relation. -/
theorem powerSet_completeLattice (S : Type u) : Nonempty (CompleteLattice (Set S)) :=
  ⟨by infer_instance⟩