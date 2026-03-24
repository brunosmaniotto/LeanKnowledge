import Mathlib
open scoped Pointwise

theorem Multiple_of_Infimum (T : Set ℝ) (hT : T.Nonempty) (h_bdd : BddBelow T) (z : ℝ) (hz : z > 0) :
    sInf (z • T) = z * sInf T := by
  have hz' : 0 ≤ z := by linarith
  exact Real.sInf_smul_of_nonneg hz' T