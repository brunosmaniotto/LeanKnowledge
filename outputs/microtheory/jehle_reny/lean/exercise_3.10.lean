import Mathlib

/-- Leontief production: y = min(α·x₁, β·x₂) -/
noncomputable def leontiefProd (α β x₁ x₂ : ℝ) : ℝ := min (α * x₁) (β * x₂)

/-- On the efficient locus of Leontief production (α·x₁ = β·x₂),
    the input ratio x₂/x₁ = α/β, a constant independent of output.
    Since the ratio never changes, the elasticity of substitution σ = 0. -/
theorem exercise_3_10 (α β x₁ x₂ : ℝ) (hα : 0 < α) (hβ : 0 < β)
    (hx₁ : 0 < x₁) (hlocus : α * x₁ = β * x₂) :
    x₂ / x₁ = α / β := by
  have hβne : β ≠ 0 := ne_of_gt hβ
  have hx₁ne : x₁ ≠ 0 := ne_of_gt hx₁
  rw [div_eq_div_iff hx₁ne hβne]
  linarith