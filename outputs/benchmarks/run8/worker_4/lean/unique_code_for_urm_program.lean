import Mathlib

inductive URMInstruction
  | zero (n : ℕ)
  | succ (n : ℕ)
  | copy (i j : ℕ)
  | jump (i j k : ℕ)

open URMInstruction

def β : URMInstruction → ℕ
  | zero n => 5 * n + 1
  | succ n => 5 * n + 2
  | copy i j => 5 * (Nat.pair i j) + 3
  | jump i j k => 5 * (Nat.pair i (Nat.pair j k)) + 4