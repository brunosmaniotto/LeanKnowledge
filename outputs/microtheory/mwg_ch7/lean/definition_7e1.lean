import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- A mixed strategy for a player assigns a probability to each pure strategy. -/
structure MixedStrategy (S : Type*) [Fintype S] [DecidableEq S] where
  prob : S → ℝ
  prob_nonneg : ∀ s, 0 ≤ prob s
  prob_sum_one : ∑ s : S, prob s = 1