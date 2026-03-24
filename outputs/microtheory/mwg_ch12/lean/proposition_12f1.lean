import Mathlib

open Filter Topology

theorem Proposition_12F1
    (p : ℝ → ℝ) (hp : Continuous p)
    (x_bar : ℝ) (q_bar : ℝ) (c_bar : ℝ)
    (hp_xbar : p x_bar = c_bar) :
    Tendsto (fun α : ℝ => p ((α * x_bar - q_bar) / α) - c_bar) atTop (nhds 0) := by
  have hq : Tendsto (fun α : ℝ => q_bar / α) atTop (nhds 0) := by
    simp_rw [div_eq_mul_inv]
    rw [show (0 : ℝ) = q_bar * 0 from (mul_zero q_bar).symm]
    exact tendsto_const_nhds.mul tendsto_inv_atTop_zero
  have key : Tendsto (fun α : ℝ => (α * x_bar - q_bar) / α) atTop (nhds x_bar) := by
    have heq : ∀ᶠ α : ℝ in atTop, (α * x_bar - q_bar) / α = x_bar - q_bar / α := by
      filter_upwards [eventually_gt_atTop (0 : ℝ)] with α hα
      field_simp
    rw [tendsto_congr' heq]
    have : Tendsto (fun α : ℝ => x_bar - q_bar / α) atTop (nhds (x_bar - 0)) :=
      tendsto_const_nhds.sub hq
    simp at this
    exact this
  have hp_tend : Tendsto (fun α : ℝ => p ((α * x_bar - q_bar) / α)) atTop (nhds c_bar) := by
    rw [← hp_xbar]
    exact (hp.tendsto x_bar).comp key
  rw [show (0 : ℝ) = c_bar - c_bar from (sub_self c_bar).symm]
  exact hp_tend.sub tendsto_const_nhds