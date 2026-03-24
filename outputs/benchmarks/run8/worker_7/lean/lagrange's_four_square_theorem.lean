import Mathlib

-- The natural number version: every positive natural number is the sum of four squares.
theorem lagrange_four_square_nat (n : ℕ) (hn : n > 0) : ∃ a b c d : ℕ, a ^ 2 + b ^ 2 + c ^ 2 + d ^ 2 = n :=
  Nat.sum_four_squares n

-- The integer version: every positive integer is the sum of four squares.