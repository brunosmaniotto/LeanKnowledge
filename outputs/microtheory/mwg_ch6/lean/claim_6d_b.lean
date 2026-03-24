import Mathlib

open Finset BigOperators
open BigOperators

theorem claim_6D_b :
    ∃ (pF pG : Fin 3 → ℝ) (x : Fin 3 → ℝ),
      (∀ i, 0 ≤ pF i) ∧ (∑ i : Fin 3, pF i = 1) ∧
      (∀ i, 0 ≤ pG i) ∧ (∑ i : Fin 3, pG i = 1) ∧
      -- F has strictly higher mean
      (∑ i : Fin 3, pF i * x i) > (∑ i : Fin 3, pG i * x i) ∧
      -- But FOSD fails: ∃ t with CDF_F(t) > CDF_G(t)
      (∃ t : ℝ, (∑ i : Fin 3, if x i ≤ t then pF i else 0) >
                 (∑ i : Fin 3, if x i ≤ t then pG i else 0)) := by
  -- x = (0, 1, 4), pF = (1/2, 1/4, 1/4), pG = (1/4, 1/2, 1/4)
  -- Mean_F = 0 + 1/4 + 1 = 5/4, Mean_G = 0 + 1/2 + 1 = 3/2? No.
  -- x = (0, 1, 10), pF = (1/4, 1/4, 1/2), pG = (1/4, 1/2, 1/4)
  -- Mean_F = 0 + 1/4 + 5 = 21/4, Mean_G = 0 + 1/2 + 5/2 = 3. mean_F > mean_G ✓
  -- CDF at 1: pF(0)+pF(1) = 1/2, pG(0)+pG(1) = 3/4. 1/2 < 3/4 ✓ FOSD holds
  -- Need CDF_F > CDF_G somewhere. At 0: 1/4 = 1/4. Equal.
  -- pF = (1/2, 0, 1/2), pG = (1/4, 1/2, 1/4), x = (0, 1, 10)
  -- Mean_F = 5, Mean_G = 1/2 + 5/2 = 3. mean_F > mean_G ✓
  -- CDF at 0: 1/2 > 1/4 ✓ FOSD fails!
  refine ⟨![1/2, 0, 1/2], ![1/4, 1/2, 1/4], ![0, 1, 10],
          ?_, ?_, ?_, ?_, ?_, ?_⟩
  · intro i; fin_cases i <;> simp [Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons] <;> norm_num
  · simp [Fin.sum_univ_three, Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons]; ring
  · intro i; fin_cases i <;> simp [Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons] <;> norm_num
  · simp [Fin.sum_univ_three, Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons]; ring
  · simp [Fin.sum_univ_three, Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons]; norm_num
  · refine ⟨0, ?_⟩
    simp [Fin.sum_univ_three, Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons]
    norm_num