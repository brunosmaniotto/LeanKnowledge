import Mathlib

open Finset
open BigOperators
open Real
open ArithmeticFunction

noncomputable def primes_le (x : ℝ) : Finset ℕ :=
  (Finset.range (Nat.floor x + 1)).filter Nat.Prime

noncomputable def exponents (p : ℕ) (N : ℕ) : Finset ℕ :=
  Finset.Icc 1 (Nat.log p N)

noncomputable def ψ1 (x : ℝ) : ℝ :=
  ∑ p ∈ primes_le x, ∑ k ∈ exponents p (Nat.floor x), Real.log (p : ℝ)

noncomputable def ψ2 (x : ℝ) : ℝ :=
  ∑ n ∈ Finset.Icc 1 (Nat.floor x), (vonMangoldt n : ℝ)

noncomputable def ψ3 (x : ℝ) : ℝ :=
  ∑ p ∈ primes_le x, (Nat.log p (Nat.floor x) : ℝ) * Real.log (p : ℝ)

theorem equivalence_of_chebyshev_defs (x : ℝ) : ψ1 x = ψ2 x ∧ ψ2 x = ψ3 x := by
  constructor
  · sorry
  · sorry