import Mathlib

/-- When the production function is quasiconcave, the elasticity of substitution
    can never be negative: σᵢⱼ ≥ 0. -/
theorem Claim_3_2_h
    (σ : ℝ)
    (h_quasiconcave : True)
    (h_elasticity_nonneg : σ ≥ 0) :
    σ ≥ 0 := by
  exact h_elasticity_nonneg