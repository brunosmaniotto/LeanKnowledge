import Mathlib

open BigOperators
open Topology

/-- Definition 6.B.1: A simple lottery over `N` outcomes. -/
structure SimpleLottery (N : ℕ) where
  prob : Fin N → ℝ
  prob_nonneg : ∀ n, 0 ≤ prob n
  prob_sum : ∑ n, prob n = 1