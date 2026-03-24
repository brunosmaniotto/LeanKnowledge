import Mathlib
open Topology

theorem claim_A1_1_2_c :
    ∀ (α : Type) (P : α → Prop),
      (∃ x, ¬ P x) → ¬ (∀ x, P x) := by
  intro α P ⟨x, hx⟩ h
  exact hx (h x)