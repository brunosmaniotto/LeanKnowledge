import Mathlib
open Topology

theorem claim_A1_1_2_a (A B : Prop) (h : ¬(A → ¬B)) : A → B := by
  tauto