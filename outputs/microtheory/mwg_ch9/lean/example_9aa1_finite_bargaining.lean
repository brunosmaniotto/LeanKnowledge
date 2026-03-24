import Mathlib

open Finset BigOperators Filter Topology
open Filter
open Topology
open BigOperators

theorem Example_9AA1_Finite_Bargaining
    (v δ : ℝ) (hv : 0 < v) (hδ0 : 0 < δ) (hδ1 : δ < 1) :
    -- Part 1: The alternating geometric series formula for player 1's payoff
    (∀ (T : ℕ), 0 < T →
      ∑ i ∈ Finset.range T, (-δ) ^ i = (1 - (-δ) ^ T) / (1 + δ)) ∧
    -- Part 2: As T → ∞, v * (1 - (-δ)^T) / (1 + δ) → v / (1 + δ)
    Filter.Tendsto (fun T : ℕ => v * (1 - (-δ) ^ T) / (1 + δ)) Filter.atTop
      (nhds (v / (1 + δ))) ∧
    -- Part 3: Player 2's limiting payoff is δv/(1+δ)
    v - v / (1 + δ) = δ * v / (1 + δ) := by
  have h1δ_pos : (0 : ℝ) < 1 + δ := by linarith
  have h1δ_ne : (1 : ℝ) + δ ≠ 0 := ne_of_gt h1δ_pos
  have hδn : (-δ) ≠ 1 := by linarith
  have hδn1 : -δ - 1 ≠ 0 := by linarith
  have habs : |(-δ)| < 1 := by
    rw [abs_neg, abs_of_pos hδ0]; exact hδ1
  refine ⟨?_, ?_, ?_⟩
  · -- Part 1: geometric sum formula
    intro T hT
    have hgs := geom_sum_eq hδn T
    -- hgs : ∑ i ∈ range T, (-δ)^i = ((-δ)^T - 1) / (-δ - 1)
    -- Goal: ... = (1 - (-δ)^T) / (1 + δ)
    rw [hgs]
    field_simp
    ring
  · -- Part 2: convergence to v/(1+δ)
    have hlim : Filter.Tendsto (fun n : ℕ => (-δ) ^ n) Filter.atTop (nhds 0) :=
      tendsto_pow_atTop_nhds_zero_of_abs_lt_one habs
    have key : Filter.Tendsto (fun n : ℕ => v * (1 - (-δ) ^ n) / (1 + δ)) Filter.atTop
        (nhds (v * (1 - 0) / (1 + δ))) := by
      apply Filter.Tendsto.div
      · exact Filter.Tendsto.mul tendsto_const_nhds
            (Filter.Tendsto.sub tendsto_const_nhds hlim)
      · exact tendsto_const_nhds
      · exact h1δ_ne
    simp only [sub_zero, mul_one] at key
    exact key
  · -- Part 3: algebraic identity
    field_simp
    ring