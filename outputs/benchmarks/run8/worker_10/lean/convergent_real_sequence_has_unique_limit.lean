import Mathlib

open Filter Topology

theorem Convergent_Real_Sequence_has_Unique_Limit {s : ℕ → ℝ} {l m : ℝ} 
    (hl : Tendsto s atTop (𝓝 l)) (hm : Tendsto s atTop (𝓝 m)) : l = m :=
  tendsto_nhds_unique hl hm