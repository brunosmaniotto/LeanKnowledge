import Mathlib

/-- Binomial coefficient for integers: returns `Nat.choose n k` when `0 ≤ k ≤ n`, and 0 otherwise. -/
def binom (n k : ℤ) : ℕ :=
  if h : 0 ≤ k ∧ k ≤ n then
    Nat.choose (Int.toNat n) (Int.toNat k)
  else
    0