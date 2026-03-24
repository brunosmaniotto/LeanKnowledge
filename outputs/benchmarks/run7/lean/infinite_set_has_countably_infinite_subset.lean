import Mathlib

theorem infinite_has_countably_infinite_subset {α : Type*} {s : Set α} (h : s.Infinite) :
    ∃ t ⊆ s, t.Countable ∧ t.Infinite := by
  let f_emb : ℕ ↪ s := h.natEmbedding
  let f : ℕ → α := fun n => (f_emb n).1
  have h_inj : Function.Injective f := fun x y hxy => f_emb.injective (Subtype.ext hxy)
  have h_range_subset : Set.range f ⊆ s := by
    rintro x ⟨n, rfl⟩
    exact (f_emb n).2
  refine ⟨Set.range f, h_range_subset, Set.countable_range f, Set.infinite_range_of_injective h_inj⟩