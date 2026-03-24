import Mathlib

open BigOperators

structure BasisExpansion (x : ℝ) (b : ℕ) (hb : 2 ≤ b) where
  s : ℤ
  digits : ℕ → ℕ
  digit_bound : ∀ n, digits n < b
  representation : x = (s : ℝ) + ∑' n, (digits n : ℝ) * ((b : ℝ) ^ (-(n + 1 : ℤ)))

def terminates {x : ℝ} {b : ℕ} {hb : 2 ≤ b} (h : BasisExpansion x b hb) : Prop :=
  ∃ N, ∀ n ≥ N, h.digits n = 0