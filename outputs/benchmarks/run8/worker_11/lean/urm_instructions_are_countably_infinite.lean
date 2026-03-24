import Mathlib

inductive URMInst
  | Z (n : ℕ)
  | S (n : ℕ)
  | C (m n : ℕ)
  | J (m n q : ℕ)

open URMInst

instance : Infinite URMInst := by
  refine Infinite.of_injective (λ n => Z n) ?_
  intro x y h
  injection h

def encode : URMInst → ℕ × ℕ × ℕ × ℕ
  | Z n => (0, n, 0, 0)
  | S n => (1, n, 0, 0)
  | C m n => (2, m, n, 0)
  | J m n q => (3, m, n, q)