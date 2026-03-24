import Mathlib

noncomputable def ramseySolow (u F : ℝ → ℝ) (k k' : ℝ) : ℝ := u (F k - k')

noncomputable def costAdj (u F γ : ℝ → ℝ) (k k' : ℝ) : ℝ := u (F k - k' - γ (k' - k))

/-- Cross-difference supermodularity condition -/
def HasUniformCrossSign (V : ℝ → ℝ → ℝ) : Prop :=
  ∀ k₁ k₂ k₁' k₂' : ℝ, k₁ ≤ k₂ → k₁' ≤ k₂' →
    V k₁ k₁' + V k₂ k₂' ≤ V k₁ k₂' + V k₂ k₁'