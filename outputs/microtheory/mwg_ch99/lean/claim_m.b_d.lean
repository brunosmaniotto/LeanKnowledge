import Mathlib

theorem homogeneous_level_set_slope
    (df1_x df2_x : ℝ) (t : ℝ) (r : ℝ)
    (hdf2 : df2_x ≠ 0)
    (ht : t > 0)
    (df1_tx df2_tx : ℝ)
    (h1 : df1_tx = t ^ (r - 1) * df1_x)
    (h2 : df2_tx = t ^ (r - 1) * df2_x) :
    -(df1_tx / df2_tx) = -(df1_x / df2_x) := by
  have ht_pow : t ^ (r - 1) ≠ 0 := ne_of_gt (Real.rpow_pos_of_pos ht (r - 1))
  rw [h1, h2, mul_div_mul_left _ _ ht_pow]