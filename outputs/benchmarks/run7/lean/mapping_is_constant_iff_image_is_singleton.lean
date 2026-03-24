import Mathlib
open Set

theorem constant_iff_range_singleton {α β : Type*} (f : α → β) (h : Nonempty α) :
    (∃ c, ∀ x, f x = c) ↔ ∃ c, Set.range f = {c} := by
  constructor
  · rintro ⟨c, hc⟩
    use c
    ext y
    constructor
    · intro h'
      rcases h' with ⟨x, rfl⟩
      simp [hc x]
    · intro h'
      simp at h'
      rcases h' with rfl
      obtain ⟨x⟩ := h
      exact ⟨x, hc x⟩
  · rintro ⟨c, h_range⟩
    use c
    intro x
    have : f x ∈ Set.range f := Set.mem_range_self x
    rw [h_range, Set.mem_singleton_iff] at this
    exact this