import Mathlib

/-- In a first-price sealed-bid auction with two bidders whose values are
uniform on [0,1], bidding bᵢ(v) = v/2 is a Bayesian-Nash equilibrium.
The expected payoff when the opponent uses strategy v₂/2 is
(v - b) · 2b, which is maximized at b = v/2. -/
theorem Exercise_7_23_b (v : ℝ) :
    ∀ b : ℝ, (v - v / 2) * (2 * (v / 2)) ≥ (v - b) * (2 * b) := by
  intro b
  nlinarith [sq_nonneg (v / 2 - b)]