import Mathlib
open Topology

/-- Exercise 4.29(b): With learning by doing (∂c₁/∂q₀ < 0), the two-period
    monopolist overproduces in period zero relative to the short-run optimum.
    The FOC includes the term δ·(∂c₁/∂q₀) < 0, so MR₀ < MC₀ at optimum. -/
theorem Exercise_4_29_b
    (MR₀ MC₀ : ℝ → ℝ)
    (q₀_sr q₀_star : ℝ)
    (δ dc₁_dq₀ : ℝ)
    (hδ_pos : δ > 0)
    (h_learning : dc₁_dq₀ < 0)
    -- Short-run (myopic) FOC: MR₀ = MC₀
    (h_sr_foc : MR₀ q₀_sr = MC₀ q₀_sr)
    -- Two-period FOC includes the learning externality term
    (h_lr_foc : MR₀ q₀_star = MC₀ q₀_star + δ * dc₁_dq₀)
    -- Marginal profit MR₀ − MC₀ is strictly decreasing (profit concavity)
    (h_concave : StrictAnti (fun q => MR₀ q - MC₀ q))
    : q₀_star > q₀_sr ∧ MR₀ q₀_star < MC₀ q₀_star := by
  have h_neg : δ * dc₁_dq₀ < 0 := mul_neg_of_pos_of_neg hδ_pos h_learning
  refine ⟨?_, by linarith⟩
  by_contra h; push_neg at h
  rcases eq_or_lt_of_le h with heq | hlt
  · have : MR₀ q₀_star = MC₀ q₀_star := by rw [heq]; exact h_sr_foc
    linarith
  · have := h_concave hlt; dsimp at this; linarith