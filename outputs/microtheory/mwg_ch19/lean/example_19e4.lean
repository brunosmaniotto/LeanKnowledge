import Mathlib

open Matrix

theorem Example_19E4 :
    let R : Matrix (Fin 3) (Fin 3) ℚ := !![1,0,0; 1,1,0; 1,1,1]
    R.rank = 3 := by
  simp only
  have hdet : Matrix.det (!![(1:ℚ),0,0; 1,1,0; 1,1,1]) ≠ 0 := by native_decide
  have hinv : IsUnit (!![(1:ℚ),0,0; 1,1,0; 1,1,1]) := by
    rwa [Matrix.isUnit_iff_isUnit_det, isUnit_iff_ne_zero]
  rw [Matrix.rank_of_isUnit _ hinv]
  simp [Fintype.card_fin]