import Mathlib

lemma inter_diff_distrib {α : Type*} (R S T : Set α) : (R \ S) ∩ T = (R ∩ T) \ (S ∩ T) := by
  ext x
  simp only [Set.mem_inter_iff, Set.mem_diff]
  constructor
  · intro ⟨⟨hR, hS⟩, hT⟩
    exact ⟨⟨hR, hT⟩, fun h => hS h.1⟩
  · intro ⟨⟨hR, hT⟩, h⟩
    exact ⟨⟨hR, fun hS => h ⟨hS, hT⟩⟩, hT⟩