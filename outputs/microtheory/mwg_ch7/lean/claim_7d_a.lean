import Mathlib
open Topology

/-- A strategy is a complete contingent plan: it specifies an action at every
    information set of a player, including unreachable ones. -/
theorem Claim_7D_a : ∀ (InfoSet : Type) (Action : Type) (Reachable : InfoSet → Prop)
    (strategy : InfoSet → Action) (h : InfoSet), ¬Reachable h → ∃ a : Action, strategy h = a := by
  intro InfoSet Action Reachable strategy h _
  exact ⟨strategy h, rfl⟩