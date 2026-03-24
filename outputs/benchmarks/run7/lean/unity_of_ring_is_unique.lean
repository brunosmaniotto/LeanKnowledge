import Mathlib

theorem unity_unique (R : Type u) [Ring R] (e1 e2 : R)
    (h1_left : ∀ x, e1 * x = x) (h1_right : ∀ x, x * e1 = x)
    (h2_left : ∀ x, e2 * x = x) (h2_right : ∀ x, x * e2 = x) : e1 = e2 := by
  have h1e2 : e1 * e2 = e2 := h1_left e2
  have h2e1 : e1 * e2 = e1 := h2_right e1
  rw [h2e1] at h1e2
  exact h1e2