import Mathlib

lemma symmDiff_compl_subset_left {α : Type*} (S T : Set α) : (Sᶜ \ Tᶜ) ∪ (Tᶜ \ Sᶜ) ⊆ (S \ T) ∪ (T \ S) := by
  intro x hx
  cases' hx with h1 h2
  · -- Case: x ∈ Sᶜ \ Tᶜ
    simp at h1
    obtain ⟨hxS, hxT⟩ := h1
    right
    exact ⟨hxT, hxS⟩
  · -- Case: x ∈ Tᶜ \ Sᶜ
    simp at h2
    obtain ⟨hxT, hxS⟩ := h2
    left
    exact ⟨hxS, hxT⟩