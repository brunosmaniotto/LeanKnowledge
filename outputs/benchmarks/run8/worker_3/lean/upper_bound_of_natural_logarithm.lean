import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.Analysis.SpecialFunctions.Log.Basic

theorem natural_logarithm_upper_bound {y : ℝ} (hy : 0 < y) : Real.log y ≤ y - 1 :=
  Real.log_le_sub_one_of_pos hy