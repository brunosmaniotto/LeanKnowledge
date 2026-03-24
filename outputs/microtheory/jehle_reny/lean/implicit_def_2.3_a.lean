import Mathlib
open BigOperators

/-- Bundle `x₀` is *revealed preferred* to bundle `x₁` at prices `p` if
    `x₁` was affordable when `x₀` was chosen, i.e., `p · x₁ ≤ p · x₀`. -/
def RevealedPreferred (L : ℕ) (p x₀ x₁ : Fin L → ℝ) : Prop :=
  ∑ i, p i * x₁ i ≤ ∑ i, p i * x₀ i