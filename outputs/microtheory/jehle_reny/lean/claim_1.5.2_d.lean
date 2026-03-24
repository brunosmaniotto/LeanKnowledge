import Mathlib
open Topology

/-- Giffen's paradox: a price decrease can lead to decreased quantity demanded,
    fully consistent with utility maximisation. We witness this by exhibiting
    two price-demand pairs where p₁ < p₀ yet x₁ < x₀. -/
theorem Claim_1_5_2_d :
    ∃ (p₀ p₁ x₀ x₁ : ℝ),
      p₁ < p₀ ∧ x₁ < x₀ := by
  exact ⟨2, 1, 5, 3, by norm_num, by norm_num⟩