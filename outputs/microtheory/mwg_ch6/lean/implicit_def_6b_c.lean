import Mathlib

open BigOperators
open Topology

/-- Definition 6.B.1: A simple lottery over `N` outcomes. -/
structure SimpleLottery (N : ℕ) where
  prob : Fin N → ℝ
  prob_nonneg : ∀ n, 0 ≤ prob n
  prob_sum : ∑ n, prob n = 1

/-- Implicit Definition 6.B.c: The choice domain ℒ is the set of all simple lotteries
    over a finite outcome set C with N outcomes. The decision maker has a rational
    preference relation ≿ on ℒ — i.e., a complete and transitive binary relation
    allowing comparison of any pair of simple lotteries. -/
structure RationalLotteryPreference (N : ℕ) where
  /-- The preference relation ≿ on simple lotteries -/
  pref : SimpleLottery N → SimpleLottery N → Prop
  /-- Completeness: any two lotteries are comparable -/
  complete : ∀ L L' : SimpleLottery N, pref L L' ∨ pref L' L
  /-- Transitivity -/
  trans : ∀ L L' L'' : SimpleLottery N, pref L L' → pref L' L'' → pref L L''