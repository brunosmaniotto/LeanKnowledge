import Mathlib

theorem compact_is_bounded {α : Type*} [MetricSpace α] {C : Set α} (h : IsCompact C) :
    Bornology.IsBounded C :=
  h.isBounded