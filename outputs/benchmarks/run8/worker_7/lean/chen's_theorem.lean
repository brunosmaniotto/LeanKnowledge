import Mathlib

theorem chen_theorem : ∃ N : ℕ, ∀ n ≥ N, Even n →
    (∃ p q : ℕ, Nat.Prime p ∧ Nat.Prime q ∧ n = p + q) ∨
    (∃ p s : ℕ, Nat.Prime p ∧ (∃ a b : ℕ, Nat.Prime a ∧ Nat.Prime b ∧ s = a * b) ∧ n = p + s) := by
  sorry