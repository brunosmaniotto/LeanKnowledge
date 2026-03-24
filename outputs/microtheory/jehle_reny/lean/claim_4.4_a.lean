import Mathlib

noncomputable section

open Set
open Topology

theorem Claim_4_4_a (a b c : ℝ) (hb : b > 0) :
    let W : ℝ → ℝ := fun q => a * q - (b / 2) * q ^ 2 - c * q
    let qstar := (a - c) / b
    StrictConcaveOn ℝ univ W ∧
    W qstar = (a - c) ^ 2 / (2 * b) := by
  refine ⟨⟨convex_univ, ?_⟩, ?_⟩
  · intro x hx y hy hxy t s ht hs hts
    dsimp only
    simp only [smul_eq_mul]
    have hsub : s = 1 - t := by linarith
    subst hsub
    have hne : x - y ≠ 0 := sub_ne_zero.mpr hxy
    have h1 : 0 < t * (1 - t) := mul_pos ht (by linarith)
    have h2 : 0 < (x - y) * (x - y) := by
      rcases lt_or_gt_of_ne hne with h | h
      · exact mul_pos_of_neg_of_neg h h
      · exact mul_pos h h
    nlinarith [mul_pos (mul_pos (by linarith : (0 : ℝ) < b / 2) h1) h2]
  · dsimp only
    field_simp
    ring