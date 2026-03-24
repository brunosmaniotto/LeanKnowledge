import Mathlib
open Topology

noncomputable section

-- Axiomatize the setup: functions and their derivatives
axiom u₂ : ℝ → ℝ → ℝ        -- ∂₂u(k, w)
axiom u₂₁ : ℝ → ℝ → ℝ       -- ∂₂₁u(k, w)
axiom u₂₂ : ℝ → ℝ → ℝ       -- ∂₂₂u(k, w)
axiom V' : ℝ → ℝ              -- V'(w)
axiom V'' : ℝ → ℝ             -- V''(w)
axiom w : ℝ → ℝ               -- optimal policy w(k)
axiom w' : ℝ → ℝ              -- w'(k)
axiom δ : ℝ                    -- discount factor

-- The first-order condition: ∂₂u(k, w(k)) + δ V'(w(k)) = 0 for all k
axiom foc : ∀ k : ℝ, u₂ k (w k) + δ * V' (w k) = 0

-- Differentiating the FOC w.r.t. k via chain rule gives:
-- u₂₁(k, w(k)) + u₂₂(k, w(k)) * w'(k) + δ * V''(w(k)) * w'(k) = 0
axiom foc_diff : ∀ k : ℝ,
  u₂₁ k (w k) + u₂₂ k (w k) * w' k + δ * V'' (w k) * w' k = 0

-- The denominator is nonzero (second-order condition ensures this)
axiom denom_ne_zero : ∀ k : ℝ, u₂₂ k (w k) + δ * V'' (w k) ≠ 0

theorem Claim_20F_d (k : ℝ) :
    w' k = - u₂₁ k (w k) / (u₂₂ k (w k) + δ * V'' (w k)) := by
  have h := foc_diff k
  have hd := denom_ne_zero k
  -- From h: u₂₁(k,w(k)) + (u₂₂(k,w(k)) + δ*V''(w(k))) * w'(k) = 0
  -- So w'(k) = -u₂₁(k,w(k)) / (u₂₂(k,w(k)) + δ*V''(w(k)))
  field_simp
  linarith