import Mathlib

open Topology

variable {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]

theorem Projection_from_Product_Topology_is_Continuous :
    Continuous (Prod.fst : X × Y → X) ∧ Continuous (Prod.snd : X × Y → Y) :=
  ⟨continuous_fst, continuous_snd⟩