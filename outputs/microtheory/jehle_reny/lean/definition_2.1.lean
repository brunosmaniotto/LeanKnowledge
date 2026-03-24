import Mathlib

open BigOperators

/-- The Weak Axiom of Revealed Preference (WARP) for a demand function
    x : (prices, wealth) → bundle. WARP holds if whenever x₀ is chosen at
    prices p₀ and x₁ (≠ x₀) was affordable at those prices (p₀ · x₁ ≤ p₀ · x₀),
    then x₀ was not affordable when x₁ was chosen (p₁ · x₀ > p₁ · x₁). -/
def SatisfiesWARP {L : ℕ} (x : (Fin L → ℝ) → ℝ → (Fin L → ℝ)) : Prop :=
  ∀ (p₀ p₁ : Fin L → ℝ) (w₀ w₁ : ℝ),
    let x₀ := x p₀ w₀
    let x₁ := x p₁ w₁
    x₀ ≠ x₁ →
    (∑ i : Fin L, p₀ i * x₁ i) ≤ (∑ i : Fin L, p₀ i * x₀ i) →
    (∑ i : Fin L, p₁ i * x₀ i) > (∑ i : Fin L, p₁ i * x₁ i)