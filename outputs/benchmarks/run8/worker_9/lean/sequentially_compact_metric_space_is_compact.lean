import Mathlib

open Set

variable {X : Type u} [MetricSpace X]

/-- A sequentially compact metric space is compact. -/
theorem seq_compact_metric_is_compact (h : IsSeqCompact (univ : Set X)) : CompactSpace X :=
  ⟨h.isCompact⟩