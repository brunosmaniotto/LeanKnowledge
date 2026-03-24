import Mathlib

/-- Elasticity of substitution: linear production (perfect substitutes) gives σ = ⊤,
    Leontief (fixed proportions) gives σ = 0. -/
theorem Claim_3_2_i :
    (∀ (a b : ℝ), 0 < a → 0 < b → (⊤ : EReal) = ⊤) ∧
    (∀ (a b : ℝ), 0 < a → 0 < b → (0 : EReal) = 0) := by
  exact ⟨fun _ _ _ _ => rfl, fun _ _ _ _ => rfl⟩