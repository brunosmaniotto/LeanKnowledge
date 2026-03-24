import Mathlib
open Filter Topology

theorem Sequence_of_Powers_of_Reciprocals_is_Null_Sequence (r : ℚ) (hr : 0 < r) :
    Tendsto (fun n : ℕ => (1 : ℝ) / ((n : ℝ) ^ (r : ℝ))) atTop (𝓝 0) := by
  have h_pos : 0 < (r : ℝ) := by exact mod_cast hr
  have h_tendsto_power : Tendsto (fun n : ℕ => ((n : ℝ) ^ (r : ℝ))) atTop atTop :=
    (tendsto_rpow_atTop h_pos).comp tendsto_natCast_atTop_atTop
  simpa [one_div] using tendsto_inv_atTop_zero.comp h_tendsto_power