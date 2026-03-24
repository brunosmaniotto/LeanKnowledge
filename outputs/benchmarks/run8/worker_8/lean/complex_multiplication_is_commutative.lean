import Mathlib

open Complex

theorem complex_mul_comm (z w : ℂ) : z * w = w * z := by
  refine Complex.ext ?_ ?_
  · rw [Complex.mul_re, Complex.mul_re]
    ring
  · rw [Complex.mul_im, Complex.mul_im]
    ring