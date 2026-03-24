import Mathlib

open Finset BigOperators

/-- If (B, p) is the pooling equilibrium proposal, then three conditions must hold:
    (8.5) u_l(B, p) ≥ ũ_l and u_h(B, p) ≥ u^c_h; and (8.6) p ≥ π̂B. -/
theorem Claim_8_1_pooling_necessary
    (u_l u_h : ℝ → ℝ → ℝ)  -- utility functions for low and high risk types
    (B p : ℝ)                -- benefit and premium of pooling equilibrium
    (ũ_l : ℝ)               -- reservation utility for low-risk type
    (u_c_h : ℝ)             -- competitive utility for high-risk type
    (π_hat : ℝ)             -- pooling fair premium rate
    -- From Lemma 8.1: equilibrium must give each type at least their reservation utility
    (h_lemma_81_l : u_l B p ≥ ũ_l)
    (h_lemma_81_h : u_h B p ≥ u_c_h)
    -- Zero-profit condition: insurance company accepts only if premium ≥ pooling fair premium × benefit
    (h_zero_profit : p ≥ π_hat * B)
    : (u_l B p ≥ ũ_l) ∧ (u_h B p ≥ u_c_h) ∧ (p ≥ π_hat * B) := by
  exact ⟨h_lemma_81_l, h_lemma_81_h, h_zero_profit⟩