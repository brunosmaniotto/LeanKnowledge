import Mathlib
open Filter
open Topology

theorem convergent_sequence_unique_limit [TopologicalSpace X] [T2Space X] {u : ℕ → X} {l m : X}
    (hl : Tendsto u atTop (𝓝 l)) (hm : Tendsto u atTop (𝓝 m)) : l = m :=
  tendsto_nhds_unique hl hm