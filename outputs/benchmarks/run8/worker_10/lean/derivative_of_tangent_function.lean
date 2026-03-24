import Mathlib
open Real

theorem hasDerivAt_tan (x : ℝ) (h : cos x ≠ 0) : HasDerivAt tan (1 / ((cos x) ^ 2)) x := by
  -- Rewrite tan as sin / cos
  rw [show tan = fun x => sin x / cos x by ext x; exact tan_eq_sin_div_cos x]
  -- Derivatives of sin and cos
  have Hsin : HasDerivAt sin (cos x) x := hasDerivAt_sin x
  have Hcos : HasDerivAt cos (-sin x) x := hasDerivAt_cos x
  -- Apply quotient rule
  convert HasDerivAt.div Hsin Hcos h using 1
  -- Simplify numerator using ring operations and Pythagorean identity
  have H : cos x * cos x - sin x * (-sin x) = cos x ^ 2 + sin x ^ 2 := by ring
  rw [H, cos_sq_add_sin_sq]