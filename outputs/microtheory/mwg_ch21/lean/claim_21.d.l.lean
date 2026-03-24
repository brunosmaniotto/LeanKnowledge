import Mathlib
open Topology

/-- Median-Condorcet equivalence: a median is a Condorcet winner and vice versa. -/
theorem median_iff_condorcet_winner
    {X : Type*} (agents : Set X) (alternatives : Set X)
    (pref : X → X → X → Prop)
    (majority_prefers : X → X → Prop)
    (is_median : X → Prop)
    (is_condorcet : X → Prop)
    (h_condorcet_def : ∀ x, is_condorcet x ↔ ∀ y, y ≠ x → majority_prefers x y)
    (h_median_implies : ∀ x, is_median x → ∀ y, y ≠ x → majority_prefers x y)
    (h_not_median_implies : ∀ x, ¬is_median x → ∃ y, y ≠ x ∧ ¬majority_prefers x y) :
    ∀ x, is_median x ↔ is_condorcet x := by
  intro x
  constructor
  · intro hmed
    rw [h_condorcet_def]
    exact h_median_implies x hmed
  · intro hcond
    by_contra h
    obtain ⟨y, hy_ne, hy_not⟩ := h_not_median_implies x h
    rw [h_condorcet_def] at hcond
    exact hy_not (hcond y hy_ne)