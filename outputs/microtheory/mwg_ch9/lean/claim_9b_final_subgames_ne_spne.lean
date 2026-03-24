import Mathlib
open Topology

/-- A final subgame has no proper nested subgames, so its only subgame is itself.
    We model this abstractly: given a type of strategy profiles and predicates for
    NE and SPNE, if SPNE means "NE in every subgame" and the only subgame is itself,
    then NE and SPNE coincide. -/
theorem final_subgame_NE_eq_SPNE
    {Subgame : Type*}
    {σ : Type*}
    (self : Subgame)
    (subgames : Subgame → Finset Subgame)
    (isNE : Subgame → σ → Prop)
    (isSPNE : σ → Prop)
    (h_final : subgames self = {self})
    (h_spne_def : ∀ s, isSPNE s ↔ ∀ g ∈ subgames self, isNE g s) :
    ∀ s, isSPNE s ↔ isNE self s := by
  intro s
  rw [h_spne_def]
  simp [h_final]