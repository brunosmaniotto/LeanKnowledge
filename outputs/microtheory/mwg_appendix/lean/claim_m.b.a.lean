import Mathlib
open Topology

theorem homogeneous_degree_zero_normalization
    {N : ℕ} (f : (Fin (N + 1) → ℝ) → ℝ)
    (hf : ∀ (t : ℝ) (x : Fin (N + 1) → ℝ), t > 0 → f (fun i => t * x i) = f x)
    (x : Fin (N + 1) → ℝ) (hx1 : x 0 > 0) :
    f (fun i => if i = 0 then 1 else x i / x 0) = f x := by
  have h := hf (x 0)⁻¹ x (inv_pos.mpr hx1)
  convert h using 1
  congr 1
  ext i
  by_cases hi : i = 0
  · subst hi; simp [inv_mul_cancel₀ (ne_of_gt hx1)]
  · simp [hi, inv_mul_eq_div]