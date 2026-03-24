import Mathlib

noncomputable section

/-- Under symmetry, the optimal selling mechanism allocates to the highest-value
    bidder provided their value exceeds the threshold ρ* where J(ρ*)=0.
    We model this as: if J is strictly monotone and J(ρ*)=0, then
    (1) J(v) > 0 iff v > ρ*, and
    (2) the bidder with the highest value has the highest virtual valuation. -/
theorem optimal_selling_mechanism_symmetric
    (J : ℝ → ℝ) (ρ_star : ℝ)
    (hJ_mono : StrictMono J)
    (hJ_threshold : J ρ_star = 0) :
    (∀ v : ℝ, v > ρ_star → J v > 0) ∧
    (∀ v : ℝ, v < ρ_star → J v < 0) ∧
    (∀ v₁ v₂ : ℝ, v₁ > v₂ → J v₁ > J v₂) := by
  refine ⟨fun v hv => ?_, fun v hv => ?_, fun v₁ v₂ hv => hJ_mono hv⟩
  · have := hJ_mono hv
    linarith
  · have := hJ_mono hv
    linarith