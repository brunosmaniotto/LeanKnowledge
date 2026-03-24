import Mathlib

variable {G : Type*}

/-- The class of VNM utility representations is characterized by constancy of
    ratios of utility differences: any positive affine transform v = α + β·u
    preserves all such ratios. -/
theorem claim_2E_e (u : G → ℝ) (α β : ℝ) (hβ : 0 < β)
    (v : G → ℝ) (hv : ∀ g, v g = α + β * u g)
    (g₁ g₂ g₃ : G) (hne : u g₂ - u g₃ ≠ 0) :
    (v g₁ - v g₂) / (v g₂ - v g₃) = (u g₁ - u g₂) / (u g₂ - u g₃) := by
  have hβne : β ≠ 0 := hβ.ne'
  have h1 : v g₁ - v g₂ = β * (u g₁ - u g₂) := by simp only [hv]; ring
  have h2 : v g₂ - v g₃ = β * (u g₂ - u g₃) := by simp only [hv]; ring
  rw [h1, h2, div_eq_div_iff (mul_ne_zero hβne hne) hne]
  ring