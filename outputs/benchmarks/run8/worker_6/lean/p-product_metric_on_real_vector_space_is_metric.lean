import Mathlib
open Finset
open Real

variable {n : ℕ} (p : ℝ) (hp : 1 ≤ p)

noncomputable def dist_p (x y : Fin n → ℝ) : ℝ :=
  (∑ i, |x i - y i| ^ p) ^ (1 / p)

lemma dist_p_nonneg (x y : Fin n → ℝ) : 0 ≤ dist_p p x y := by
  unfold dist_p
  exact Real.rpow_nonneg (Finset.sum_nonneg fun i _ => Real.rpow_nonneg (abs_nonneg _) p) (1 / p)