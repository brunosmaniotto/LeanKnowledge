import Mathlib

theorem compact_subspace_of_hausdorff_is_closed {A : Type*} [TopologicalSpace A] [T2Space A]
    {C : Set A} (hC : IsCompact C) : IsClosed C :=
  hC.isClosed