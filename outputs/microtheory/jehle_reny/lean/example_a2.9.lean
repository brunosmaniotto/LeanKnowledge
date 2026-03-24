import Mathlib

open Matrix

theorem Example_A2_9 (a b : ℝ) (ha : 0 < a) (hb : 0 < b) :
    det (!![( 0 : ℝ), 1, 1; 1, -2*a, 0; 1, 0, -2*b]) = 2 * (a + b) ∧
    (0 : ℝ) < 2 * (a + b) ∧
    b / (a + b) + a / (a + b) = 1 ∧
    -a * (b / (a + b)) ^ 2 - b * (a / (a + b)) ^ 2 =
      -(a * b ^ 2 + b * a ^ 2) / (a + b) ^ 2 := by
  have hab : a + b ≠ 0 := by linarith
  refine ⟨?_, by linarith, ?_, ?_⟩
  · simp [det_fin_three]; ring
  · field_simp; ring
  · field_simp; ring