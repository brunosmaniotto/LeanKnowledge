import Mathlib

theorem Example_3_D_1
    (α w p₁ p₂ : ℝ)
    (hα₀ : 0 < α) (hα₁ : α < 1)
    (hw : 0 < w) (hp₁ : 0 < p₁) (hp₂ : 0 < p₂) :
    let x₁ := α * w / p₁
    let x₂ := (1 - α) * w / p₂
    p₁ * x₁ + p₂ * x₂ = w
    ∧ p₁ * x₁ = α * w
    ∧ p₂ * x₂ = (1 - α) * w := by
  refine ⟨?_, ?_, ?_⟩
  · show p₁ * (α * w / p₁) + p₂ * ((1 - α) * w / p₂) = w
    have hp₁' : p₁ ≠ 0 := ne_of_gt hp₁
    have hp₂' : p₂ ≠ 0 := ne_of_gt hp₂
    field_simp
    ring
  · show p₁ * (α * w / p₁) = α * w
    have hp₁' : p₁ ≠ 0 := ne_of_gt hp₁
    field_simp
  · show p₂ * ((1 - α) * w / p₂) = (1 - α) * w
    have hp₂' : p₂ ≠ 0 := ne_of_gt hp₂
    field_simp