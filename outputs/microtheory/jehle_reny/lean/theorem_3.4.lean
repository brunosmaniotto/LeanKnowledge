import Mathlib

noncomputable section
open Real

theorem theorem_3_4
    (finv : ℝ → ℝ) (hm : StrictMono finv) (hp : 0 < finv 1)
    (α : ℝ) (hα : 0 < α) :
    StrictMono (fun y => finv y / finv 1) ∧
    StrictMonoOn (fun y : ℝ => y ^ (1 / α)) (Set.Ici 0) := by
  constructor
  · intro a b hab
    simp only [div_eq_mul_inv]
    exact mul_lt_mul_of_pos_right (hm hab) (inv_pos.mpr hp)
  · intro a ha b hb hab
    exact rpow_lt_rpow (Set.mem_Ici.mp ha) hab (div_pos one_pos hα)