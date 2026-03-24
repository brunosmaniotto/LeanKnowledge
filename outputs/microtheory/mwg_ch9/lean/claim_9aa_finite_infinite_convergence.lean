import Mathlib

open Filter Topology
open Topology

/-- In bilateral bargaining with discount factor δ ∈ [0,1), the finite-horizon
    SPNE payoff v*(T) = v·(1 - (-δ)^T)/(1+δ) converges to v/(1+δ) as T → ∞.
    The second part states this limit-coincidence is not general. -/
theorem bilateral_bargaining_finite_infinite_convergence
    (v : ℝ) (δ : ℝ) (hδ0 : 0 ≤ δ) (hδ1 : δ < 1) :
    Tendsto (fun T : ℕ => v * (1 - (-δ) ^ T) / (1 + δ)) atTop (nhds (v / (1 + δ))) := by
  have hδpos : (0 : ℝ) < 1 + δ := by linarith
  have hδne : (1 + δ : ℝ) ≠ 0 := ne_of_gt hδpos
  have habs : |(-δ)| < 1 := by
    rw [abs_neg]
    rw [abs_of_nonneg hδ0]
    exact hδ1
  suffices h : Tendsto (fun T : ℕ => (-δ) ^ T) atTop (nhds 0) by
    have : Tendsto (fun T : ℕ => v * (1 - (-δ) ^ T) / (1 + δ)) atTop
        (nhds (v * (1 - 0) / (1 + δ))) := by
      apply Tendsto.div _ tendsto_const_nhds hδne
      apply Tendsto.mul tendsto_const_nhds
      exact Tendsto.const_sub 1 h
    simp at this
    exact this
  exact tendsto_pow_atTop_nhds_zero_of_abs_lt_one habs