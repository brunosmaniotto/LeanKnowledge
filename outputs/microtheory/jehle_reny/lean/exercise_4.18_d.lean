import Mathlib

open Real

/-- When income elasticity η is constant and not equal to unity, the approximate
    percentage deviation of CV from |CS| satisfies (CV − |CS|)/|CS| ≈ (η·|CS|)/(2y⁰).

    We formalize the algebraic content: if CV = cs + η * cs^2 / (2 * y0),
    then (CV - cs) / cs = η * cs / (2 * y0), where cs = |CS| > 0. -/
theorem exercise_4_18_d
    (η cs y0 : ℝ)
    (hcs : cs > 0)
    (hy0 : y0 > 0)
    (CV : ℝ)
    (hCV : CV = cs + η * cs ^ 2 / (2 * y0)) :
    (CV - cs) / cs = η * cs / (2 * y0) := by
  rw [hCV]
  field_simp
  ring