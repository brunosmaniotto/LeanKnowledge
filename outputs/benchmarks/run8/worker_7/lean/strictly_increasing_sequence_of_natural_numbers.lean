import Mathlib

theorem seq_lower_bound (n : ℕ → ℕ) (h_pos : ∀ i, 1 ≤ n i) (h_incr : ∀ i, n i < n (i + 1)) : ∀ r : ℕ, n r ≥ r + 1 := by
  intro r
  induction' r with k IH
  · exact h_pos 0
  · have hk := h_incr k
    omega