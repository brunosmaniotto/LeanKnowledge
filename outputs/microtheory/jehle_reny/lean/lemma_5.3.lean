import Mathlib
open Topology

/-- The sequence of core sets C_1, C_2, ... in a replica economy is decreasing:
    C₁ ⊇ C₂ ⊇ ⋯ ⊇ Cᵣ ⊇ ⋯
    Any coalition that blocks in Eᵣ₋₁ can also block in Eᵣ, so the core
    can only shrink as r increases. -/
theorem Lemma_5_3 {α : Type*} (canBlock : ℕ → α → Prop)
    (h_mono : ∀ r s : ℕ, r ≤ s → ∀ x, canBlock r x → canBlock s x) :
    Antitone (fun r => {x : α | ¬ canBlock r x}) := by
  intro r s hrs x hx
  simp only [Set.mem_setOf_eq] at hx ⊢
  exact fun h => hx (h_mono r s hrs x h)