import Mathlib

lemma exists_moved_point {n : ℕ} (σ : Equiv.Perm (Fin n)) (h : σ ≠ 1) : ∃ i : Fin n, σ i ≠ i := by
  by_contra h_contra
  push_neg at h_contra
  -- h_contra : ∀ i : Fin n, σ i = i
  -- This means σ fixes all points, so σ = 1
  have : σ = 1 := by
    ext i
    simp [h_contra i]
  exact h this