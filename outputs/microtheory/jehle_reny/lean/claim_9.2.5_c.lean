import Mathlib
open MeasureTheory

theorem Claim_9_2_5_c (b_hat f F : ℝ → ℝ) (N : ℕ) :
    ∫ v in (0:ℝ)..1, b_hat v * ((↑N : ℝ) * f v * F v ^ (N - 1)) =
    (↑N : ℝ) * ∫ v in (0:ℝ)..1, b_hat v * (f v * F v ^ (N - 1)) := by
  have key : (fun v => b_hat v * ((↑N : ℝ) * f v * F v ^ (N - 1))) =
    (fun v => (↑N : ℝ) • (b_hat v * (f v * F v ^ (N - 1)))) := by
    ext v; simp only [smul_eq_mul]; ring
  rw [key, intervalIntegral.integral_smul, smul_eq_mul]