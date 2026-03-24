import Mathlib
open Topology

theorem Claim_A1_1_1_d {A B : Prop} (h : A → B) : ¬B → ¬A := by
  intro hnb ha
  exact hnb (h ha)