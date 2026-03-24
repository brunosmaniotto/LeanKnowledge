import Mathlib

open Real
open Topology

/-- Claim_12C_i: With capacity constraints q̄ < x(c), each firm can guarantee
    strictly positive sales at a strictly positive profit margin by pricing
    in (c, p(q̄)), so competition does not drive price to cost. -/
theorem Claim_12C_i
    -- Demand function x(p) and inverse demand p(q)
    (x : ℝ → ℝ) (p_inv : ℝ → ℝ)
    -- Marginal cost
    (c : ℝ)
    -- Capacity constraint
    (q_bar : ℝ)
    -- c is positive
    (hc_pos : c > 0)
    -- q_bar is positive
    (hq_pos : q_bar > 0)
    -- Capacity is strictly less than demand at cost
    (hcap : q_bar < x c)
    -- x is continuous
    (hx_cont : Continuous x)
    -- x is strictly decreasing on relevant range
    (hx_anti : StrictAnti x)
    -- p_inv is the inverse demand: p_inv(x(p)) = p for relevant prices
    (hp_inv_left : ∀ p, x p > 0 → p_inv (x p) = p)
    -- x(p_inv(q)) = q for relevant quantities
    (hx_right : ∀ q, q > 0 → x (p_inv q) = q)
    -- p_inv is strictly decreasing
    (hp_inv_anti : StrictAnti p_inv)
    -- Demand at cost is positive
    (hxc_pos : x c > 0)
    : -- There exists a price p₁ ∈ (c, p_inv(q_bar)) such that
      -- residual demand is positive and profit margin is positive
      ∃ p₁ : ℝ, p₁ > c ∧ p₁ < p_inv q_bar ∧
        x p₁ - q_bar > 0 ∧ (p₁ - c) * (x p₁ - q_bar) > 0 := by
  -- Since q_bar < x(c), and x is strictly decreasing, p_inv(q_bar) > p_inv(x(c)) = c
  have hpq_gt_c : p_inv q_bar > c := by
    have h1 : p_inv (x c) = c := hp_inv_left c hxc_pos
    rw [← h1]
    exact hp_inv_anti hcap
  -- x is continuous and x(c) > q_bar, x(p_inv(q_bar)) = q_bar
  -- So for any p₁ between c and p_inv(q_bar), x(p₁) > q_bar by strict monotonicity
  -- Choose p₁ = (c + p_inv q_bar) / 2
  refine ⟨(c + p_inv q_bar) / 2, ?_, ?_, ?_, ?_⟩
  · linarith
  · linarith
  · -- Need x((c + p_inv q_bar) / 2) > q_bar
    -- Since (c + p_inv q_bar) / 2 < p_inv q_bar and x is strictly decreasing
    have hmid_lt : (c + p_inv q_bar) / 2 < p_inv q_bar := by linarith
    have hxmid : x ((c + p_inv q_bar) / 2) > x (p_inv q_bar) := hx_anti hmid_lt
    have hx_at_qbar : x (p_inv q_bar) = q_bar := hx_right q_bar hq_pos
    linarith
  · -- Profit = (p₁ - c) * (x(p₁) - q_bar) > 0, product of two positives
    have hp1_gt_c : (c + p_inv q_bar) / 2 > c := by linarith
    have hmid_lt : (c + p_inv q_bar) / 2 < p_inv q_bar := by linarith
    have hxmid : x ((c + p_inv q_bar) / 2) > x (p_inv q_bar) := hx_anti hmid_lt
    have hx_at_qbar : x (p_inv q_bar) = q_bar := hx_right q_bar hq_pos
    have hresidual : x ((c + p_inv q_bar) / 2) - q_bar > 0 := by linarith
    have hmargin : (c + p_inv q_bar) / 2 - c > 0 := by linarith
    exact mul_pos hmargin hresidual