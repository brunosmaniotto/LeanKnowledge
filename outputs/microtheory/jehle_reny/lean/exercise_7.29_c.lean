import Mathlib

/-- In the Take-it-or-leave-it game with N dollars, the backward induction
    strategies (offer 0, accept all offers) form a Nash equilibrium. -/
theorem Exercise_7_29_c (N : ℕ) :
    (∀ offer' : ℕ, offer' ≤ N →
      N ≥ (if (0 : ℕ) ≤ offer' then N - offer' else 0)) ∧
    (∀ threshold' : ℕ,
      (0 : ℕ) ≥ (if threshold' ≤ 0 then (0 : ℕ) else 0)) := by
  constructor
  · intro offer' _
    split_ifs <;> omega
  · intro threshold'
    split_ifs <;> omega