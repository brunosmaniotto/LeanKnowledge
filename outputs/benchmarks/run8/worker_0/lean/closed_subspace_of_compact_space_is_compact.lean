import Mathlib

open Set

theorem closed_subspace_of_compact_is_compact {T : Type _} [TopologicalSpace T] [CompactSpace T]
    {C : Set T} (hC : IsClosed C) : IsCompact C :=
  hC.isCompact