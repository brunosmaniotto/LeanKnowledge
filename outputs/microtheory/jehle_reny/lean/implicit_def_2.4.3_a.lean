import Mathlib

open BigOperators
open Topology

/-- The outcome set for wealth gambles: all non-negative wealth levels, A = ℝ₊. -/
abbrev WealthOutcome := NNReal

/-- A simple gamble over non-negative wealth levels.
    Represents (p₁ ◦ w₁, …, pₙ ◦ wₙ) where n is a positive integer,
    wᵢ are non-negative wealth levels, and pᵢ are non-negative probabilities summing to 1. -/
structure SimpleGamble where
  /-- Number of outcomes with specified probabilities -/
  n : ℕ
  /-- n is a positive integer -/
  hn : 0 < n
  /-- Non-negative wealth levels w₁, …, wₙ -/
  outcomes : Fin n → NNReal
  /-- Non-negative probabilities p₁, …, pₙ -/
  probs : Fin n → NNReal
  /-- Probabilities sum to 1 -/
  probs_sum : ∑ i, probs i = 1