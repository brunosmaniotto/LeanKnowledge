import Mathlib

open Real
open Topology

theorem caplin_nalebuff_supermajority_bound :
    (1 : ℝ) - Real.exp (-1) > 1 / 2 ∧ Real.exp (-1) < 1 / 2 := by
  have hexp_pos : (0 : ℝ) < Real.exp 1 := exp_pos 1
  have hexp_neg : Real.exp (-1) = (Real.exp 1)⁻¹ := Real.exp_neg 1
  -- Show exp(1) > 2
  have hexp_gt_two : Real.exp 1 > 2 := by
    have h1 : (1 : ℝ) + 1 ≤ Real.exp 1 := Real.add_one_le_exp 1
    -- exp(1) ≥ 2, but we need strict. Use exp(0.5) ≥ 1.5 twice, or note exp is strictly convex
    -- Actually, use that exp(1) ≥ 1 + 1 + 1/2 * 1^2 / 2! ... let's just use nlinarith with known bounds
    have h2 : (0 : ℝ) < Real.exp (1/2) := exp_pos (1/2)
    have h3 : (1 : ℝ) + 1/2 ≤ Real.exp (1/2) := by
      have := Real.add_one_le_exp (1/2 : ℝ)
      linarith
    have h4 : Real.exp 1 = Real.exp (1/2) * Real.exp (1/2) := by
      rw [← Real.exp_add]; norm_num
    nlinarith
  -- Now derive exp(-1) < 1/2
  have hexp_neg_lt : Real.exp (-1) < 1 / 2 := by
    rw [hexp_neg]
    rw [inv_lt_comm₀ (by positivity) (by positivity)]
    linarith
  exact ⟨by linarith, hexp_neg_lt⟩