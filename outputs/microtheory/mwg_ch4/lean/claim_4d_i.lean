import Mathlib

open Matrix BigOperators
open Topology

theorem claim_4D_i :
    ∃ (S : Matrix (Fin 2) (Fin 2) ℝ)
      (S₁ S₂ : Matrix (Fin 2) (Fin 2) ℝ),
      S.IsSymm ∧
      (∀ v : Fin 2 → ℝ, v ≠ 0 → dotProduct v (S.mulVec v) < 0) ∧
      ¬(∀ v : Fin 2 → ℝ, 0 ≤ dotProduct v ((S₁ + S₂ - S).mulVec v)) := by
  refine ⟨!![(-2 : ℝ), 0; 0, -1], !![(-1 : ℝ), 0; 0, -1], !![(-1 : ℝ), 0; 0, -1], ?_, ?_, ?_⟩
  · ext i j
    fin_cases i <;> fin_cases j <;> simp [Matrix.transpose_apply]
  · intro v hv
    simp only [dotProduct, mulVec, Fin.sum_univ_two, of_apply,
      cons_val', cons_val_zero, empty_val', cons_val_one]
    have hne : v 0 ≠ 0 ∨ v 1 ≠ 0 := by
      by_contra h
      push_neg at h
      exact hv (funext (Fin.forall_fin_two.mpr ⟨h.1, h.2⟩))
    rcases hne with h | h
    · nlinarith [sq_pos_of_ne_zero h, sq_nonneg (v 1)]
    · nlinarith [sq_pos_of_ne_zero h, sq_nonneg (v 0)]
  · push_neg
    refine ⟨![0, 1], ?_⟩
    simp only [dotProduct, mulVec, Fin.sum_univ_two, of_apply,
      cons_val', cons_val_zero, empty_val', cons_val_one,
      Matrix.sub_apply, Matrix.add_apply]
    norm_num