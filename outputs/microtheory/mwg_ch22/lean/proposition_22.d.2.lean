import Mathlib

open Finset BigOperators
open Topology
open BigOperators

theorem Proposition_22D2
    {I : ℕ} (hI : 0 < I)
    (W : (Fin I → ℝ) → ℝ)
    (mean : (Fin I → ℝ) → ℝ)
    (hmean : ∀ u, mean u = (∑ i : Fin I, u i) / I)
    (g : (Fin I → ℝ) → ℝ)
    (hg : ∀ u, g u = mean u - W u)
    (htransl : ∀ u (α : ℝ), W (fun i => u i + α) = W u + α)
    (hscale : ∀ u (β : ℝ), 0 < β → W (fun i => β * u i) = β * W u) :
    (∀ u, W u = mean u - g (fun i => u i - mean u)) ∧
    (∀ (s : Fin I → ℝ), (∑ i : Fin I, s i) = 0 →
      ∀ (β : ℝ), 0 < β → g (fun i => β * s i) = β * g s) := by
  have hI_ne : (I : ℝ) ≠ 0 := Nat.cast_ne_zero.mpr (by omega)
  constructor
  · intro u
    have hdev_eq : (fun i => u i - mean u) = (fun i => u i + (-(mean u))) := by
      ext i; ring
    have hW_dev : W (fun i => u i - mean u) = W u - mean u := by
      rw [hdev_eq, htransl]; ring
    have hmean_dev : mean (fun i => u i - mean u) = 0 := by
      rw [hmean]
      have : ∑ i : Fin I, (u i - mean u) = (∑ i : Fin I, u i) - I * mean u := by
        rw [Finset.sum_sub_distrib]
        simp [Finset.card_univ, Finset.sum_const, nsmul_eq_mul]
      rw [this, hmean u]
      field_simp
      ring
    rw [hg, hmean_dev, hW_dev]; ring
  · intro s hs β hβ
    have hmean_s : mean s = 0 := by
      rw [hmean, hs]; simp
    have hmean_bs : mean (fun i => β * s i) = 0 := by
      rw [hmean]
      simp only [← Finset.mul_sum]
      rw [hs]; simp
    rw [hg, hg, hmean_bs, hmean_s, hscale s β hβ]; ring