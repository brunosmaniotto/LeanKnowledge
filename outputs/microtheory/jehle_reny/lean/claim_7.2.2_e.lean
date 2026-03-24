import Mathlib
open Topology

-- The structure of a mixed strategy, defined as a probability mass function over a finite set of pure strategies S.
structure MixedStrategy (S : Type*) [Fintype S] [DecidableEq S] where
  toFun : S → ℝ
  nonneg' : ∀ s, toFun s ≥ 0
  sum_one' : Finset.univ.sum toFun = 1

-- A helper function to define a degenerate probability distribution.
-- It assigns probability 1 to a single strategy `s₀` and 0 to all others.
def degenerate_pmf {S : Type*} [Fintype S] [DecidableEq S] (s₀ : S) : S → ℝ :=
  fun s => if s = s₀ then 1 else 0

-- Axioms representing the given facts about the degenerate_pmf.
-- These would normally be proven, but are accepted as true for this exercise.
axiom degenerate_pmf_nonneg {S : Type*} [Fintype S] [DecidableEq S] (s₀ : S) (s : S) : (degenerate_pmf s₀ s) ≥ 0
axiom degenerate_pmf_sum_one {S : Type*} [Fintype S] [DecidableEq S] (s₀ : S) : Finset.univ.sum (degenerate_pmf s₀) = 1

-- Theorem: Every pure strategy can be represented as a degenerate mixed strategy.