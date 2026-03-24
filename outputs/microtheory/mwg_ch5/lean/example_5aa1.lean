import Mathlib

open Matrix

theorem Example_5AA1 (β : ℝ) :
    let A : Matrix (Fin 2) (Fin 2) ℝ := !![0, β; 1, 0]
    (1 - A).det = 1 - β := by
  simp [det_fin_two, Matrix.sub_apply]