import Mathlib
open Topology

theorem claim_A1_1_2_b (A B : Prop) : (A ↔ B) ↔ ((A → B) ∧ (B → A)) :=
  ⟨fun h => ⟨h.mp, h.mpr⟩, fun h => ⟨h.1, h.2⟩⟩