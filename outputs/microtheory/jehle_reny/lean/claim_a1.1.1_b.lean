import Mathlib
open Topology

theorem contrapositive_reversal {A B : Prop} (h : B → A) : ¬A → ¬B := by
  intro hna hb
  exact hna (h hb)