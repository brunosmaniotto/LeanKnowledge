import Mathlib
open Real

theorem exists_irrational_pow_irrational_rational : ∃ (a b : ℝ), Irrational a ∧ Irrational b ∧ ¬ Irrational (a ^ b) := by
  have sqrt2_irr : Irrational (Real.sqrt 2) := irrational_sqrt_two
  have nonneg_sqrt2 : 0 ≤ Real.sqrt 2 := Real.sqrt_nonneg 2
  by_cases h : Irrational ((Real.sqrt 2) ^ (Real.sqrt 2))
  · have H : ((Real.sqrt 2) ^ (Real.sqrt 2)) ^ (Real.sqrt 2) = (2 : ℝ) := by
      calc
        ((Real.sqrt 2) ^ (Real.sqrt 2)) ^ (Real.sqrt 2) = (Real.sqrt 2) ^ ((Real.sqrt 2) * (Real.sqrt 2)) := by
          rw [← Real.rpow_mul nonneg_sqrt2]
        _ = (Real.sqrt 2) ^ (2 : ℝ) := by rw [Real.mul_self_sqrt (show 0 ≤ (2 : ℝ) from by norm_num)]
        _ = (Real.sqrt 2) ^ (2 : ℕ) := by norm_num
        _ = (Real.sqrt 2) ^ 2 := by norm_num
        _ = 2 := Real.sq_sqrt (by norm_num)
    refine ⟨(Real.sqrt 2) ^ (Real.sqrt 2), Real.sqrt 2, h, sqrt2_irr, ?_⟩
    rw [H]
    intro h2
    exact h2 ⟨(2 : ℚ), by norm_num⟩
  · refine ⟨Real.sqrt 2, Real.sqrt 2, sqrt2_irr, sqrt2_irr, h⟩