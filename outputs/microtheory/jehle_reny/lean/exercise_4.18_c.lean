import Mathlib

open Real Filter Topology
open Filter

noncomputable def willigBound (η CS w : ℝ) : ℝ := CS * (1 + η * CS / (2 * w))

theorem Exercise_4_18_c (CS w : ℝ) (hw : w > 0) (hCS : CS ≥ 0) :
    Filter.Tendsto (fun η => willigBound η CS w) (nhds 1) (nhds (willigBound 1 CS w)) := by
  unfold willigBound
  apply Filter.Tendsto.mul
  · exact tendsto_const_nhds
  · apply Filter.Tendsto.add
    · exact tendsto_const_nhds
    · apply Filter.Tendsto.div_const
      apply Filter.Tendsto.mul
      · exact tendsto_id
      · exact tendsto_const_nhds