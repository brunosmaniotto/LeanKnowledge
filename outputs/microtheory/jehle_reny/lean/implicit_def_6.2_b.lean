import Mathlib

/-- A society is composed of N individuals, where N ≥ 2. -/
structure Society where
  N : ℕ
  hN : 2 ≤ N