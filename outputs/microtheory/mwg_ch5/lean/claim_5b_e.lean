import Mathlib
open Topology

theorem Claim_5B_e {n : ℕ} {Y : Set (Fin n → ℝ)} (hY : Convex ℝ Y)
    (y y' : Fin n → ℝ) (hy : y ∈ Y) (hy' : y' ∈ Y) :
    (fun i => (1 / 2 : ℝ) * y i + (1 / 2 : ℝ) * y' i) ∈ Y := by
  have h : (fun i => (1 / 2 : ℝ) * y i + (1 / 2 : ℝ) * y' i) =
    (1 / 2 : ℝ) • y + (1 / 2 : ℝ) • y' := by
    ext i
    simp [Pi.add_apply, Pi.smul_apply, smul_eq_mul]
  rw [h]
  exact hY hy hy' (by norm_num : (0 : ℝ) ≤ 1 / 2) (by norm_num : (0 : ℝ) ≤ 1 / 2) (by norm_num : (1 / 2 : ℝ) + 1 / 2 = 1)