import Mathlib

structure SetRing (α : Type u) where
  sets : Set (Set α)
  empty_mem : ∅ ∈ sets
  union_mem : ∀ ⦃s t⦄, s ∈ sets → t ∈ sets → s ∪ t ∈ sets
  diff_mem : ∀ ⦃s t⦄, s ∈ sets → t ∈ sets → s \ t ∈ sets

namespace SetRing

variable {α : Type u} (R : SetRing α)

theorem inter_mem {s t : Set α} (hs : s ∈ R.sets) (ht : t ∈ R.sets) : s ∩ t ∈ R.sets := by
  have h : s ∩ t = s \ (s \ t) := by
    ext x
    constructor
    · intro ⟨hxs, hxt⟩
      exact ⟨hxs, by intro h; exact h.2 hxt⟩
    · intro ⟨hxs, h⟩
      have : x ∉ s \ t := h
      simp only [Set.mem_diff, not_and, not_not] at this
      exact ⟨hxs, this hxs⟩
  rw [h]
  exact R.diff_mem hs (R.diff_mem hs ht)