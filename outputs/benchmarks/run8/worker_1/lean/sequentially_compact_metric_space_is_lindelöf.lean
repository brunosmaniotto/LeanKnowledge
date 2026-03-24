import Mathlib

open Topology

theorem sequentially_compact_metric_is_lindelof (M : Type*) [MetricSpace M] [SeqCompactSpace M] :
    LindelofSpace M := by
  have : CompactSpace M := by
    rw [compactSpace_iff_seqCompactSpace]
    exact inferInstance
  exact inferInstance