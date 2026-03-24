import Mathlib

theorem method_of_infinite_descent (P : ℕ → Prop) (h : ∀ n, P n → ∃ k < n, P k) : ∀ n, ¬ P n := by
  intro n
  induction n using Nat.strong_induction_on with
  | h n ih =>
    intro hP
    rcases h n hP with ⟨k, hk, hPk⟩
    exact ih k hk hPk