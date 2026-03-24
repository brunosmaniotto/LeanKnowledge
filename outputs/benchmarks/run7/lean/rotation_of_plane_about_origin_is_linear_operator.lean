import Mathlib

noncomputable def planeRotation (α : ℝ) : (ℝ × ℝ) →ₗ[ℝ] ℝ × ℝ where
  toFun p := (p.1 * Real.cos α - p.2 * Real.sin α, p.1 * Real.sin α + p.2 * Real.cos α)
  map_add' x y := by
    ext <;> simp <;> ring
  map_smul' c x := by
    ext <;> simp <;> ring