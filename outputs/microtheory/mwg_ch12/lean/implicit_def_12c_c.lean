import Mathlib

/-- The Cournot duopoly model: two firms simultaneously choose quantities q₁, q₂.
    Price adjusts to clear the market via an inverse demand function p(·) with p'(q) < 0. -/
structure CournotModel where
  /-- Inverse demand function: maps total quantity to market price. -/
  p : ℝ → ℝ
  /-- Common constant marginal cost, positive. -/
  c : ℝ
  /-- The competitive output level where price equals cost. -/
  q_o : ℝ
  hc_pos : 0 < c
  hp_diff : Differentiable ℝ p
  hp_neg_slope : ∀ q : ℝ, 0 < q → deriv p q < 0
  hp_zero : c < p 0
  hq_o_pos : 0 < q_o
  hp_at_qo : p q_o = c
  hq_o_unique : ∀ q : ℝ, 0 < q → p q = c → q = q_o