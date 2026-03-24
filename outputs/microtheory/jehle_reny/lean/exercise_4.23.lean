import Mathlib
open Topology

/-- (Ramsey Rule) For a regulated monopolist with costs C = cq + F, the welfare-maximizing
    price p* subject to non-negative profit satisfies (i) p* > c and
    (ii) (p* − c)/p* is proportional to 1/ε* (inverse elasticity rule). -/
theorem Exercise_4_23
    (p_star c F q_star ε_star : ℝ)
    (hc_pos : c > 0) (hF_pos : F > 0) (hq_pos : q_star > 0)
    (hp_pos : p_star > 0) (hε_pos : ε_star > 0)
    -- Binding profit constraint at the optimum: (p* − c)·q* − F = 0
    (h_profit : (p_star - c) * q_star = F)
    -- Lagrange multiplier on the profit constraint
    (mu : ℝ) (hmu_pos : mu > 0)
    -- First-order Ramsey condition from constrained welfare maximization
    (h_ramsey : (p_star - c) / p_star = (mu / (1 + mu)) * (1 / ε_star)) :
    -- (i) p* > c and (ii) ∃ k > 0 such that (p* − c)/p* = k · (1/ε*)
    p_star > c ∧ ∃ k : ℝ, k > 0 ∧ (p_star - c) / p_star = k * (1 / ε_star) := by
  constructor
  · -- (i): if p* ≤ c then (c − p*)q* ≥ 0, but that equals −F < 0, contradiction
    by_contra h
    push_neg at h
    have h1 : c - p_star ≥ 0 := by linarith
    have h2 : (c - p_star) * q_star ≥ 0 := mul_nonneg h1 (le_of_lt hq_pos)
    have h3 : (c - p_star) * q_star = -((p_star - c) * q_star) := by ring
    linarith
  · -- (ii): take k = μ/(1+μ) > 0
    exact ⟨mu / (1 + mu), by positivity, h_ramsey⟩