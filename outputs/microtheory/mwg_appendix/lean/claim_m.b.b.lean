import Mathlib

theorem homogeneous_deg_one_normalize
    {N : ℕ} [NeZero N] (f : (Fin N → ℝ) → ℝ)
    (hf : ∀ (t : ℝ) (x : Fin N → ℝ), f (fun i => t * x i) = t * f x)
    (x : Fin N → ℝ) (hx : x 0 > 0) :
    f (fun i => if i = 0 then 1 else x i / x 0) = (1 / x 0) * f x := by
  have hx0 : x 0 ≠ 0 := ne_of_gt hx
  have key := hf (1 / x 0) x
  convert key using 1
  congr 1
  ext i
  by_cases hi : i = 0
  · subst hi
    simp [one_div, inv_mul_cancel₀ hx0]
  · simp only [hi, ite_false, one_div]
    field_simp