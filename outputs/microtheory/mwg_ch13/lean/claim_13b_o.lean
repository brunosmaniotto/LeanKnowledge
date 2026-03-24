import Mathlib
open Topology

theorem pareto_full_implies_constrained_not_converse :
    -- Part 1: For any property P and sets S ⊆ T,
    -- (∀ t ∈ T, ¬P t) → (∀ s ∈ S, ¬P s)
    (∀ (α : Type) (P : α → Prop) (S T : Set α),
      S ⊆ T → (∀ t ∈ T, ¬P t) → (∀ s ∈ S, ¬P s)) ∧
    -- Part 2: There exist P, S ⊂ T where constrained optimality holds but full doesn't
    (∃ (P : Nat → Prop) (S T : Set Nat),
      S ⊆ T ∧ (∀ s ∈ S, ¬P s) ∧ ¬(∀ t ∈ T, ¬P t)) := by
  constructor
  · intro α P S T hST hT s hs
    exact hT s (hST hs)
  · refine ⟨fun n => n = 0, {1}, {0, 1}, ?_, ?_, ?_⟩
    · intro x hx; simp [Set.mem_insert_iff]; simp at hx; exact Or.inr hx
    · intro s hs; simp at hs; omega
    · push_neg; exact ⟨0, by simp, rfl⟩