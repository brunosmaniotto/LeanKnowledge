import Mathlib
open Topology

/-- Aggregate demand satisfying WA is less demanding than invariance to redistribution:
    invariance implies WA, but WA can hold without invariance. -/
theorem aggregate_demand_WA_less_demanding_than_invariance
    {α : Type*}
    (WA : α → Prop)
    (Invariance : α → Prop)
    (h_inv_implies_wa : ∀ a, Invariance a → WA a)
    (h_wa_not_implies_inv : ∃ a, WA a ∧ ¬Invariance a) :
    (∀ a, Invariance a → WA a) ∧ ¬(∀ a, WA a → Invariance a) := by
  exact ⟨h_inv_implies_wa, fun h => by
    obtain ⟨a, hwa, hinv⟩ := h_wa_not_implies_inv
    exact hinv (h a hwa)⟩