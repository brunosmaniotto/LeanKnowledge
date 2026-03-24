import Mathlib

open MeasureTheory ENNReal

-- Define the VCG cost functions as specified in the theorem statement.
noncomputable def c_VCG_b_fn (t_b t_s : ℝ) : ℝ :=
  if t_b > t_s then t_s else 0