import Mathlib
open Topology

theorem Claim_8_2_alpha_low
    (π π_bar : ℝ)
    (hπ_lt : π < π_bar)
    (threshold : ℝ)
    (h_thresh_lo : π < threshold)
    (h_thresh_hi : threshold < π_bar) :
    -- (1) pooling premium is strictly decreasing in α
    (∀ α₁ α₂ : ℝ, α₁ < α₂ →
      α₂ * π + (1 - α₂) * π_bar < α₁ * π + (1 - α₁) * π_bar) ∧
    -- (2) at α = 0, pooling premium = π̄
    (0 * π + (1 - 0) * π_bar = π_bar) ∧
    -- (3) at α = 1, pooling premium = π
    (1 * π + (1 - 1) * π_bar = π) ∧
    -- (4) ∃ critical α ∈ (0,1): for all α ≤ α_crit, pooling premium ≥ threshold
    (∃ α_crit : ℝ, 0 < α_crit ∧ α_crit < 1 ∧
      ∀ α : ℝ, 0 ≤ α → α ≤ α_crit →
        α * π + (1 - α) * π_bar ≥ threshold) := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · -- Monotone decreasing in α
    intro α₁ α₂ h; nlinarith
  · -- π_hat(0) = π_bar
    ring
  · -- π_hat(1) = π
    ring
  · -- Critical α exists: choose α_crit = (π̄ - threshold) / (π̄ - π)
    have hd : (0 : ℝ) < π_bar - π := by linarith
    have hn : (0 : ℝ) < π_bar - threshold := by linarith
    refine ⟨(π_bar - threshold) / (π_bar - π), div_pos hn hd, ?_, ?_⟩
    · rw [div_lt_one hd]; linarith
    · intro α _ hα_le
      have step1 : α * (π_bar - π) ≤ (π_bar - threshold) / (π_bar - π) * (π_bar - π) :=
        mul_le_mul_of_nonneg_right hα_le (le_of_lt hd)
      have step2 : (π_bar - threshold) / (π_bar - π) * (π_bar - π) = π_bar - threshold := by
        field_simp
      nlinarith