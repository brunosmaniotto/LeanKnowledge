import Mathlib

-- Proved sub-lemma
lemma fraction_with_neg_num_den_eq {F : Type*} [Field F] {x y : F} (hy : y ≠ 0) : x / y = -x / -y := by
  rw [neg_div_neg_eq]

-- Main theorem