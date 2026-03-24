import Mathlib

theorem schur_theorem (r : ℕ) (hr : 0 < r) : ∃ S : ℕ, ∀ (f : ℕ → Fin r), ∃ x y z : ℕ,
    1 ≤ x ∧ x ≤ S ∧ 1 ≤ y ∧ y ≤ S ∧ 1 ≤ z ∧ z ≤ S ∧ x + y = z ∧ f x = f y ∧ f y = f z := by
  sorry