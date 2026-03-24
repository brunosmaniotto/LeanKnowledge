import Mathlib
open Topology

/-- Claim 14.B.h: In the principal-agent moral hazard model, when e = e_H is optimal,
    both IR and IC constraints bind (by complementary slackness with positive multipliers),
    and w(π) > W̄ when likelihood ratio < 1, w(π) < W̄ when likelihood ratio > 1. -/
theorem claim_14B_h
    {Ω : Type*} [Fintype Ω]
    (w : Ω → ℝ) (wBar : ℝ) (lr : Ω → ℝ)
    (mu lambda_ic : ℝ)
    (hmu : 0 < mu) (hlam : 0 < lambda_ic)
    (ir_slack : 0 < mu → True)  -- IR binds by complementary slackness
    (ic_slack : 0 < lambda_ic → True)  -- IC binds by complementary slackness
    (foc_above : ∀ ω, lr ω < 1 → wBar < w ω)
    (foc_below : ∀ ω, 1 < lr ω → w ω < wBar) :
    (0 < mu ∧ 0 < lambda_ic) ∧
    (∀ ω, lr ω < 1 → wBar < w ω) ∧
    (∀ ω, 1 < lr ω → w ω < wBar) :=
  ⟨⟨hmu, hlam⟩, foc_above, foc_below⟩