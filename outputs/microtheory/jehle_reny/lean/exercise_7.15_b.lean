import Mathlib
open Topology

/-- Finiteness is essential for undominated NE: the Bertrand duopoly (infinite strategy
    space ℝ) has Nash equilibria but every NE is dominated, so no undominated NE exists. -/
theorem Exercise_7_15_b
    (IsNE : ℝ → Prop) (Dom : ℝ → ℝ → Prop)
    (hNE : ∃ s, IsNE s)
    (hAllDom : ∀ s, IsNE s → ∃ s', Dom s' s) :
    ¬∃ s, IsNE s ∧ ∀ s', ¬Dom s' s := by
  rintro ⟨s, hsNE, hsUndom⟩
  obtain ⟨s', hs'⟩ := hAllDom s hsNE
  exact hsUndom s' hs'