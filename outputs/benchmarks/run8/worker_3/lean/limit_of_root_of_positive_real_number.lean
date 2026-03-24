import Mathlib

open Filter Topology

theorem Limit_of_Root_of_Positive_Real_Number (x : ℝ) (hx : x > 0) :
    Tendsto (fun n : ℕ => x ^ (1 / (n : ℝ))) atTop (𝓝 1) := by
  simp_rw [Real.rpow_def_of_pos hx, mul_one_div]
  have h_arg_lim : Tendsto (fun n : ℕ => Real.log x / (n : ℝ)) atTop (𝓝 0) :=
    tendsto_const_div_atTop_nhds_zero_nat (Real.log x)
  exact Real.tendsto_exp_nhds_zero_nhds_one.comp h_arg_lim