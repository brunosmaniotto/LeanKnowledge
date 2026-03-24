import Mathlib
open Topology

/-- An Asymmetrical Rectangular 2-Person Bidding Game (Vickrey 1961).
Bidder 1 draws value v₁ from Uniform(0,1); Bidder 2 draws value v₂ from Uniform(a,b)
with b ≥ 1. The functions y₁, y₂ give bid CDFs and v₁, v₂ give the inverse
bid functions (value drawings leading to a given bid). -/
structure AsymRectBiddingGame where
  /-- Lower bound of Bidder 2's value distribution -/
  a : ℝ
  /-- Upper bound of Bidder 2's value distribution -/
  b : ℝ
  /-- The upper bound satisfies b ≥ 1 -/
  hb_ge : b ≥ 1
  /-- The bounds are ordered: a ≤ b -/
  ha_le_b : a ≤ b
  /-- Bid CDF for Bidder 1: y₁(x) = P(bid₁ < x) -/
  y₁ : ℝ → ℝ
  /-- Bid CDF for Bidder 2: y₂(x) = P(bid₂ < x) -/
  y₂ : ℝ → ℝ
  /-- Inverse bid function for Bidder 1: the value drawing that leads to bid x -/
  v₁ : ℝ → ℝ
  /-- Inverse bid function for Bidder 2: the value drawing that leads to bid x -/
  v₂ : ℝ → ℝ