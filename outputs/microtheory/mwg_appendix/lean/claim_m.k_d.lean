import Mathlib
open Topology

/-
  For a nonnegativity constraint xₙ ≥ 0, the first-order condition for xₙ becomes
  ∂f/∂xₙ - Σ λₘ ∂gₘ/∂xₙ - Σ λₖ ∂hₖ/∂xₙ ≤ 0 with equality if x̄ₙ > 0.

  We model this by introducing the nonnegativity constraint as an additional inequality
  h_{K+1}(x) = -xₙ ≤ 0 with multiplier μ ≥ 0, and showing complementary slackness
  μ · x̄ₙ = 0 yields the result.
-/

theorem Claim_M_K_d
    (df : ℝ)           -- ∂f/∂xₙ at x̄
    (dg_sum : ℝ)       -- Σₘ λₘ ∂gₘ/∂xₙ at x̄
    (dh_sum : ℝ)       -- Σₖ λₖ ∂hₖ/∂xₙ at x̄
    (μ : ℝ)            -- multiplier for the nonnegativity constraint
    (x_n : ℝ)          -- x̄ₙ
    (hμ_nonneg : μ ≥ 0)
    (hx_nonneg : x_n ≥ 0)
    -- Complementary slackness: μ · x̄ₙ = 0
    (h_comp_slack : μ * x_n = 0)
    -- Standard KKT first-order condition with the extra constraint h_{K+1}(x) = -xₙ:
    -- ∂f/∂xₙ - dg_sum - dh_sum - μ·(−1) = 0, i.e., df - dg_sum - dh_sum + μ = 0
    (h_kkt : df - dg_sum - dh_sum + μ = 0) :
    -- Then df - dg_sum - dh_sum ≤ 0, with equality when x̄ₙ > 0
    (df - dg_sum - dh_sum ≤ 0) ∧
    (x_n > 0 → df - dg_sum - dh_sum = 0) := by
  constructor
  · -- From h_kkt: df - dg_sum - dh_sum = -μ, and μ ≥ 0 implies -μ ≤ 0
    linarith
  · -- If x̄ₙ > 0, complementary slackness forces μ = 0
    intro hx_pos
    have hμ_zero : μ = 0 := by
      rcases mul_eq_zero.mp h_comp_slack with h | h
      · exact h
      · linarith
    linarith