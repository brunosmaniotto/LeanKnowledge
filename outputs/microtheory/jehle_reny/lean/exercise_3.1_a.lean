import Mathlib

/--
The elasticity of average product AP_i(x) = f(x)/x_i with respect to x_i
equals μ_i(x) − 1, where μ_i(x) = (∂f/∂x_i)(x_i/f(x)) is the output elasticity.
-/
theorem Exercise_3_1_a
    (f xi MPi : ℝ)
    (hxi : xi ≠ 0)
    (hf : f ≠ 0) :
    ((MPi * xi - f) / xi ^ 2) * xi / (f / xi) = MPi * xi / f - 1 := by
  field_simp