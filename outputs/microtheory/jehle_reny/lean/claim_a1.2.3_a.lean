import Mathlib
open Topology

theorem claim_A1_2_3_a :
    ¬ (∀ x y : Fin 10, (x.val + 1) > (y.val + 1) ∨ (y.val + 1) > (x.val + 1)) := by
  intro h
  have := h ⟨0, by omega⟩ ⟨0, by omega⟩
  simp at this