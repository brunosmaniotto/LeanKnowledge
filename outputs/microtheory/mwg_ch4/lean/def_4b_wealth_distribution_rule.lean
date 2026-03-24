import Mathlib
open Topology
open BigOperators

structure WealthDistributionRule (J : ℕ) where
  /-- Each consumer's wealth as a function of price vector and aggregate wealth -/
  w : Fin J → (Fin J → ℝ) → ℝ → ℝ
  /-- Individual wealths sum to aggregate wealth -/
  sum_eq : ∀ (p : Fin J → ℝ) (agg : ℝ), ∑ i, w i p agg = agg