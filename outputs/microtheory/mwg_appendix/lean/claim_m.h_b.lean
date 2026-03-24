import Mathlib

open Set Filter Topology
open Topology

/-- If f is a function (single-valued correspondence), then lower hemicontinuity
    (preimage of every open set is open) coincides with continuity of f as a function. -/
theorem claim_M_H_b {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]
    (f : X → Y) :
    Continuous f ↔ (∀ V : Set Y, IsOpen V → IsOpen (f ⁻¹' V)) := by
  constructor
  · intro hf V hV
    exact hV.preimage hf
  · intro h
    rw [continuous_def]
    exact h