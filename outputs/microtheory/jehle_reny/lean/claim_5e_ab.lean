import Mathlib

theorem walrasian_mrs_mrts_eq_price_ratio
    {L : ℕ} (p : Fin L → ℝ) (hp : ∀ l, 0 < p l)
    (mu_i : Fin L → ℝ) (lam_i : ℝ) (hlam_i : 0 < lam_i)
    (hfoc_i : ∀ l, mu_i l = lam_i * p l)
    (mu_j : Fin L → ℝ) (lam_j : ℝ) (hlam_j : 0 < lam_j)
    (hfoc_j : ∀ l, mu_j l = lam_j * p l)
    (mp_f : Fin L → ℝ) (mu_f : ℝ) (hmu_f : 0 < mu_f)
    (hfoc_f : ∀ l, mp_f l = mu_f * p l)
    (l k : Fin L) :
    mu_i l / mu_i k = p l / p k ∧
    mu_i l / mu_i k = mu_j l / mu_j k ∧
    mp_f l / mp_f k = p l / p k := by
  have hlam_i_ne : lam_i ≠ 0 := ne_of_gt hlam_i
  have hlam_j_ne : lam_j ≠ 0 := ne_of_gt hlam_j
  have hmu_f_ne : mu_f ≠ 0 := ne_of_gt hmu_f
  refine ⟨?_, ?_, ?_⟩
  · rw [hfoc_i l, hfoc_i k]; field_simp
  · rw [hfoc_i l, hfoc_i k, hfoc_j l, hfoc_j k]; field_simp
  · rw [hfoc_f l, hfoc_f k]; field_simp