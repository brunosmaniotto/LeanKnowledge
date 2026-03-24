import Mathlib
open Topology

/-- In a first-price sealed-bid auction with two bidders whose values are
independently drawn from Uniform[0,1], bidding half one's value is a
Bayesian-Nash equilibrium: if the opponent uses b(v₂) = v₂/2, then
bidding v/2 maximizes expected payoff (v - b) · Pr[win] = (v - b) · 2b. -/
theorem Exercise_7_23_b (v b : ℝ) :
    (v - v / 2) * (2 * (v / 2)) ≥ (v - b) * (2 * b) := by
  nlinarith [sq_nonneg (b - v / 2)]