import Mathlib

open Topology Set

theorem Invoked_Theorem_A1_6
    {α β : Type*} [TopologicalSpace α] [TopologicalSpace β]
    (f : α → β) :
    Continuous f ↔ ∀ s, IsOpen s → IsOpen (f ⁻¹' s) :=
  continuous_def