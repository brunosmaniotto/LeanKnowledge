import Mathlib

variable {α β : Type}

theorem image_subset_codomain (R : Set (α × β)) (S : Set α) (T : Set β) (hR : R = S ×ˢ T)
    (A : Set α) (hA : A ⊆ S) : {b | ∃ a, a ∈ A ∧ (a, b) ∈ R} ⊆ T := by
  intro b hb
  rcases hb with ⟨a, ha, h⟩
  rw [hR] at h
  exact (Set.mem_prod.mp h).2