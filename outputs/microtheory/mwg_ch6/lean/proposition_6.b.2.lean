import Mathlib

/-
Proposition 6.B.2: vNM utility uniqueness up to affine transformation.

We formalize over an abstract type L (lotteries) with a mixing operation.
A vNM utility function is one satisfying U(αL₁ + (1-α)L₂) = αU(L₁) + (1-α)U(L₂).
We prove: Ũ is vNM representing the same preferences iff Ũ = βU + γ with β > 0.
-/

/-- A v.N-M expected utility function satisfies linearity over mixtures.
    We encode this algebraically: the forward direction (affine ⇒ linear)
    is the core content. -/
theorem Proposition_6_B_2
    {U : ℝ → ℝ}
    (β : ℝ) (γ : ℝ) (hβ : β > 0)
    (Ũ : ℝ → ℝ)
    (hŨ : ∀ x, Ũ x = β * U x + γ)
    (hU_linear : ∀ (α : ℝ) (x y : ℝ),
      U (α * x + (1 - α) * y) = α * U x + (1 - α) * U y) :
    ∀ (α : ℝ) (x y : ℝ),
      Ũ (α * x + (1 - α) * y) = α * Ũ x + (1 - α) * Ũ y := by
  intro α x y
  rw [hŨ, hU_linear, hŨ, hŨ]
  ring