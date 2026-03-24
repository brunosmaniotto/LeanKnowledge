import Mathlib

open Set Topology

/-- From the first-order conditions of the Lagrangian alone, one cannot determine
    whether the critical point is a constrained maximum or minimum.
    We exhibit f₁(x)=x² and f₂(x)=-x² with constraint g(x)=x, both satisfying
    FOC at x=0 with multiplier 0, yet x=0 is a constrained min of f₁ and max of f₂. -/
theorem Claim_A2_FOCCannotDistinguishMaxMin :
    ∃ (f₁ f₂ g : ℝ → ℝ) (x₀ mu : ℝ),
      g x₀ = 0 ∧
      HasDerivAt f₁ (mu * 1) x₀ ∧
      HasDerivAt f₂ (mu * 1) x₀ ∧
      HasDerivAt g 1 x₀ ∧
      (∀ x, g x = 0 → f₁ x₀ ≤ f₁ x) ∧
      (∀ x, g x = 0 → f₂ x ≤ f₂ x₀) := by
  refine ⟨fun x => x ^ 2, fun x => -(x ^ 2), fun x => x, 0, 0,
    rfl, ?_, ?_, ?_, ?_, ?_⟩
  · norm_num
    have := hasDerivAt_pow 2 (0 : ℝ)
    simpa using this
  · norm_num
    have := (hasDerivAt_pow 2 (0 : ℝ)).neg
    simpa using this
  · simpa using hasDerivAt_id (0 : ℝ)
  · intro x hx; simp_all [sq_nonneg]
  · intro x hx; simp_all [neg_nonpos.mpr (sq_nonneg x)]