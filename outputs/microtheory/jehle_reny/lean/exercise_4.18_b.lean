import Mathlib

/-- When demand is independent of income (η = 0), the CV formula
    CV = y⁰·[(−CS/y⁰)·(1−η) + 1]^(1/(1−η)) − y⁰ reduces to CV = −CS.
    With η = 0 the exponent is 1 and the expression simplifies algebraically. -/
theorem Exercise_4_18_b (y0 CS : ℝ) (hy0 : y0 ≠ 0) :
    y0 * (-CS / y0 + 1) - y0 = -CS := by
  field_simp
  ring