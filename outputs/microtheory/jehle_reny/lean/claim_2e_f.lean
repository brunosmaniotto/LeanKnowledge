import Mathlib

noncomputable section

namespace MWG

/-- VNM utility functions cannot be used for interpersonal comparisons:
    any ordering of utility levels can be reversed by valid positive affine
    transformations, so absolute levels and differences are meaningless. -/
theorem claim_2E_f
    (u₁ u₂ : ℝ → ℝ)
    (x : ℝ)
    (h_order : u₁ x < u₂ x) :
    ∃ (α₁ β₁ α₂ β₂ : ℝ),
      0 < α₁ ∧ 0 < α₂ ∧
      α₁ * u₁ x + β₁ > α₂ * u₂ x + β₂ := by
  exact ⟨1, u₂ x - u₁ x + 1, 1, 0, by linarith, by linarith, by linarith⟩

end MWG