import Mathlib -- Covers all necessary imports
import Mathlib

open Set Filter Topology
open Filter
open Topology

-- A lemma formalizing that if an incentive function is positive at an equilibrium price
-- and is continuous, then it remains positive in a neighborhood around that price.
-- This interprets "incentives to report correctly" as a real-valued continuous function `incentive_value`,
-- and "cover a considerable range" as the existence of an open interval where this function is positive.
lemma real_continuous_at_iff_eventually_positive {f : ℝ → ℝ} {x₀ : ℝ} (h_cont : ContinuousAt f x₀)
    (h_pos : 0 < f x₀) :
    ∃ (ε : ℝ), 0 < ε ∧ ∀ (x : ℝ), x ∈ Ioo (x₀ - ε) (x₀ + ε) → 0 < f x := by
  -- The definition of ContinuousAt `f x₀` is `Tendsto f (𝓝 x₀) (𝓝 (f x₀))`.
  -- We know `0 < f x₀`. We want to show `0 < f x` for `x` in a neighborhood of `x₀`.
  -- By definition of `Tendsto` to `𝓝 (f x₀)`, for any `s ∈ 𝓝 (f x₀)`, `f⁻¹(s) ∈ 𝓝 x₀`.
  -- Since `0 < f x₀`, the interval `(0, ∞)` is a neighborhood of `f x₀`.
  have h_nhd_pos : Ioi 0 ∈ 𝓝 (f x₀) := by
    exact IsOpen.mem_nhds (isOpen_Ioi) h_pos

  -- By continuity, the preimage of `Ioi 0` under `f` is a neighborhood of `x₀`.
  have h_preimage_nhd : f ⁻¹' (Ioi 0) ∈ 𝓝 x₀ :=
    h_cont.preimage_mem_nhds h_nhd_pos

  -- A neighborhood of `x₀` contains an open interval `(x₀ - ε, x₀ + ε)` for some `ε > 0`.
  rcases Metric.mem_nhds_iff.mp h_preimage_nhd with ⟨ε, hε_pos, h_sub⟩

  -- So, we have an ε.
  use ε
  constructor
  . exact hε_pos -- 0 < ε
  . intro x hx -- For x in (x₀ - ε) (x₀ + ε), show 0 < f x.
    -- `x ∈ Ioo (x₀ - ε) (x₀ + ε)` means `x ∈ Metric.ball x₀ ε`.
    -- Since `Metric.ball x₀ ε ⊆ f ⁻¹' (Ioi 0)`, it means `f x ∈ Ioi 0`.
    have h_in_ball : x ∈ Metric.ball x₀ ε := by
      rw [Real.ball_eq_Ioo]
      exact hx
    exact h_sub h_in_ball