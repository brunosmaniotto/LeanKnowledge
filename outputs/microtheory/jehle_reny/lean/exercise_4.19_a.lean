import Mathlib
open Topology

theorem Exercise_4_19_a (p y : ℝ) (hp : p > 0) (hy : y > 1) :
    -- Budget feasibility: p · (1/p) + (y - 1) = y
    p * (1 / p) + (y - 1) = y ∧
    -- Optimality: for any feasible bundle, utility is no greater
    ∀ x' m' : ℝ, x' > 0 → m' ≥ 0 → p * x' + m' ≤ y →
      Real.log x' + m' ≤ Real.log (1 / p) + (y - 1) := by
  refine ⟨by field_simp; linarith, fun x' m' hx' _hm' hbudget => ?_⟩
  have hpx : p * x' > 0 := mul_pos hp hx'
  suffices h : Real.log x' - p * x' ≤ Real.log (1 / p) - 1 by linarith
  have hlog_x : Real.log x' = Real.log (p * x') - Real.log p := by
    rw [Real.log_mul (ne_of_gt hp) (ne_of_gt hx')]; ring
  have hlog_inv : Real.log (1 / p) = -Real.log p := by
    rw [one_div, Real.log_inv]
  have log_le : Real.log (p * x') ≤ p * x' - 1 := by
    have h := Real.add_one_le_exp (Real.log (p * x'))
    rw [Real.exp_log hpx] at h; linarith
  linarith