import Mathlib

lemma subfield_test_contains_zero (F : Type*) [Field F] (K : Set F) 
    (h_nonempty : ∃ x ∈ K, x ≠ 0) (h_sub : ∀ x ∈ K, ∀ y ∈ K, x - y ∈ K) : 0 ∈ K := by
  obtain ⟨x, hx_mem, _⟩ := h_nonempty
  have : x - x ∈ K := h_sub x hx_mem x hx_mem
  simp at this
  exact this