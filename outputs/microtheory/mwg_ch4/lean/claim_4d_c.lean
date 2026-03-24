import Mathlib

open Finset BigOperators
open BigOperators

noncomputable def gorman_v (a_i : ℝ) (b : ℝ) (w_i : ℝ) : ℝ := a_i + b * w_i

theorem gorman_compensation_forward
    {J : ℕ} (hJ : 0 < J)
    (a a' : Fin J → ℝ) (b b' w_total w_total' : ℝ)
    (hb' : 0 < b')
    (h_improve : (∑ i : Fin J, a' i) + b' * w_total' > (∑ i : Fin J, a i) + b * w_total)
    (w : Fin J → ℝ) (hw : ∑ i : Fin J, w i = w_total) :
    ∃ w' : Fin J → ℝ,
      (∑ i : Fin J, w' i = w_total') ∧
      (∀ i : Fin J, gorman_v (a' i) b' (w' i) ≥ gorman_v (a i) b (w i)) := by
  have hb'_ne : b' ≠ 0 := ne_of_gt hb'
  have hJ' : (J : ℝ) ≠ 0 := Nat.cast_ne_zero.mpr (by omega)
  set ε := (∑ i : Fin J, a' i) + b' * w_total' - ((∑ i : Fin J, a i) + b * w_total) with hε_def
  have hε : 0 < ε := by linarith
  refine ⟨fun i => (a i + b * w i - a' i + ε / ↑J) / b', ?_, ?_⟩
  · -- Sum of w'_i = w_total'
    have key : ∀ i ∈ Finset.univ, (a i + b * w i - a' i + ε / ↑J) / b' =
        (a i + b * w i - a' i + ε / ↑J) * b'⁻¹ := by
      intros; rw [div_eq_mul_inv]
    rw [Finset.sum_congr rfl key, ← Finset.sum_mul]
    have h2 : ∑ i : Fin J, (a i + b * w i - a' i + ε / ↑J) =
        (∑ i : Fin J, a i) + b * w_total - (∑ i : Fin J, a' i) + ε := by
      simp only [Finset.sum_add_distrib, Finset.sum_sub_distrib]
      rw [← Finset.mul_sum, hw]
      simp only [Finset.sum_const, Finset.card_fin, nsmul_eq_mul]
      field_simp
    rw [h2]
    field_simp [hε_def]
    ring
  · -- Each agent weakly better off
    intro i
    simp only [gorman_v]
    rw [ge_iff_le, ← sub_nonneg]
    have : a' i + b' * ((a i + b * w i - a' i + ε / ↑J) / b') - (a i + b * w i) =
        ε / ↑J := by
      field_simp
      ring
    linarith [div_pos hε (Nat.cast_pos.mpr hJ)]