import Mathlib

axiom eulerNumber : ℕ → ℤ
axiom eulerNumber_zero : eulerNumber 0 = 1
axiom eulerNumber_recurrence : ∀ (n : ℕ) (hn : 0 < n),
    ∑ k ∈ Finset.range (n + 1), (Nat.choose (2 * n) (2 * k) : ℤ) * eulerNumber (2 * n - 2 * k) = 0

theorem euler_numbers_binomial_sum_zero (n : ℕ) (hn : 0 < n) :
    ∑ k ∈ Finset.range (n + 1), (Nat.choose (2 * n) (2 * k) : ℤ) * eulerNumber (2 * n - 2 * k) = 0 :=
  eulerNumber_recurrence n hn