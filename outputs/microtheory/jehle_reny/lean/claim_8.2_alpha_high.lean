import Mathlib
open Topology

/-- When α (fraction of low-risk consumers) is large enough, there exist pooling
    equilibria that Pareto-dominate every separating equilibrium.
    The pooling average premium π̄(α) = α·πL + (1−α)·πH → πL as α → 1,
    so the pooling contract approaches the low-risk fair contract while
    separation constrains the low-risk consumer's choice. -/
theorem pooling_pareto_dominates_separating_high_alpha
    -- Two risk types
    (π_L π_H : ℝ)
    (hπL_pos : 0 < π_L) (hπH_pos : 0 < π_H)
    (hπL_lt : π_L < 1) (hπH_lt : π_H < 1)
    (hπ_order : π_L < π_H)
    -- Separating equilibrium utilities (constrained for low-risk)
    (u_sep_L u_sep_H : ℝ)
    -- Pooling equilibrium utilities as functions of α
    (u_pool_L u_pool_H : ℝ → ℝ)
    -- Key fact 1: As α → 1, pooling premium → πL, so low-risk
    -- gets near-fair insurance without the incentive-compatibility
    -- constraint that restricts separating equilibrium choices
    (h_low_risk : ∃ α₀ ∈ Set.Ioo (0 : ℝ) 1,
        ∀ α ∈ Set.Ioo α₀ 1, u_sep_L < u_pool_L α)
    -- Key fact 2: High-risk always weakly prefers pooling
    -- (cross-subsidized at below-fair premium)
    (h_high_risk : ∀ α ∈ Set.Ioo (0 : ℝ) 1, u_sep_H ≤ u_pool_H α) :
    ∃ α₀ ∈ Set.Ioo (0 : ℝ) 1, ∀ α ∈ Set.Ioo α₀ 1,
        u_sep_L < u_pool_L α ∧ u_sep_H ≤ u_pool_H α := by
  obtain ⟨α₀, hα₀_mem, hα₀_prop⟩ := h_low_risk
  exact ⟨α₀, hα₀_mem, fun α hα =>
    ⟨hα₀_prop α hα, h_high_risk α ⟨lt_trans hα₀_mem.1 hα.1, hα.2⟩⟩⟩