import Mathlib
open Topology

/-- Short-run output choice: a firm either produces where p = MC with p ≥ AVC,
    or shuts down (produces zero) when p < AVC at the MC-crossing point. -/
theorem Claim_3_5_j
    (p : ℝ)
    (mc avc : ℝ → ℝ)
    (y_star : ℝ)
    (h_nonneg : y_star ≥ 0)
    (h_foc : y_star > 0 → p = mc y_star)
    (h_mc_nondec : y_star > 0 → ∀ y', y' ≥ y_star → mc y' ≥ mc y_star)
    (h_avc : y_star > 0 → p ≥ avc y_star)
    (h_shutdown : (∃ y₀ > 0, p = mc y₀ ∧ p < avc y₀) → y_star = 0) :
    (y_star > 0 ∧ p = mc y_star ∧ (∀ y', y' ≥ y_star → mc y' ≥ mc y_star) ∧ p ≥ avc y_star)
    ∨ (y_star = 0) := by
  by_cases h : y_star > 0
  · left
    exact ⟨h, h_foc h, h_mc_nondec h, h_avc h⟩
  · right
    linarith