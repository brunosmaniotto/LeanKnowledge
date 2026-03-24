import Mathlib

open LinearMap

noncomputable def linearOperatorEquiv : ((ℝ × ℝ) →ₗ[ℝ] ℝ × ℝ) ≃ (ℝ × ℝ × ℝ × ℝ) where
  toFun L := ((L (1, 0)).1, (L (0, 1)).1, (L (1, 0)).2, (L (0, 1)).2)
  invFun := fun (a, b, c, d) =>
    { toFun := fun (x, y) => (a * x + b * y, c * x + d * y)
      map_add' := by
        intro (x1, y1) (x2, y2)
        ext <;> simp <;> ring
      map_smul' := by
        intro r (x, y)
        ext <;> simp <;> ring }
  left_inv L := by
    apply LinearMap.ext
    intro v
    rcases v with ⟨x, y⟩
    simp only [LinearMap.coe_mk, AddHom.coe_mk]
    have h : (x, y) = x • (1, 0) + y • (0, 1) := by simp
    rw [h, L.map_add, L.map_smul, L.map_smul]
    ext <;> simp [mul_comm]
  right_inv := by
    intro (a, b, c, d)
    simp