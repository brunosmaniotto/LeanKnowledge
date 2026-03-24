import Mathlib

/-- Fermat's Last Theorem: for positive integers a, b, c and integer n > 2,
    a^n + b^n = c^n has no solutions. -/
theorem fermat_last_theorem (a b c : ℕ) (n : ℕ) (hn : n ≥ 3) (ha : a > 0) (hb : b > 0) (hc : c > 0) :
    a ^ n + b ^ n ≠ c ^ n := by
  -- The actual proof is beyond the scope of current Mathlib
  sorry