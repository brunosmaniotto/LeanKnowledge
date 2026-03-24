import Mathlib

open scoped Real
open Topology

/--
With cost function c(q) = aq + bq² where a > 0 and b < 0, the zero-profit condition
(p·q = c(q)) implies p = a + b·q (average cost), and the profit-maximization condition
(p = marginal cost) implies p = a + 2·b·q. Together these yield q = 0 and p = a.
-/
theorem Exercise_4_7_b
    (a b : ℝ) (ha : a > 0) (hb : b < 0)
    (p q : ℝ) (hq_pos : q > 0)
    -- Cost function: c(q) = a*q + b*q^2
    -- Zero-profit condition: p*q = c(q)
    (h_zero_profit : p * q = a * q + b * q ^ 2)
    -- Profit maximization (price = marginal cost): p = a + 2*b*q
    (h_profit_max : p = a + 2 * b * q) :
    -- These two conditions together imply q = 0, contradiction with q > 0,
    -- so no interior long-run equilibrium exists with positive output.
    False := by
  -- From zero-profit with q > 0: p = a + b*q
  have hq_ne : q ≠ 0 := ne_of_gt hq_pos
  have h_p_ac : p = a + b * q := by
    have := h_zero_profit
    have : p * q = (a + b * q) * q := by ring_nf; linarith
    have : (p - (a + b * q)) * q = 0 := by nlinarith
    rcases mul_eq_zero.mp this with h | h
    · linarith
    · exact absurd h hq_ne
  -- From profit max: p = a + 2*b*q
  -- So a + b*q = a + 2*b*q, giving b*q = 0
  have : b * q = 0 := by linarith
  rcases mul_eq_zero.mp this with h | h
  · linarith
  · linarith