import Mathlib
open Topology

theorem Theorem_A2_11
    (f₁₁ f₁₂ f₂₂ : ℝ) :
    (f₁₁ < 0 → f₁₁ * f₂₂ - f₁₂ ^ 2 > 0 →
      ∀ z₁ z₂ : ℝ, (z₁, z₂) ≠ (0, 0) →
        f₁₁ * z₁ ^ 2 + 2 * f₁₂ * z₁ * z₂ + f₂₂ * z₂ ^ 2 < 0) ∧
    (f₁₁ > 0 → f₁₁ * f₂₂ - f₁₂ ^ 2 > 0 →
      ∀ z₁ z₂ : ℝ, (z₁, z₂) ≠ (0, 0) →
        f₁₁ * z₁ ^ 2 + 2 * f₁₂ * z₁ * z₂ + f₂₂ * z₂ ^ 2 > 0) := by
  -- Helper: the completing-the-square RHS is positive
  have rhs_pos : ∀ {a b c x y : ℝ}, a ≠ 0 → a * c - b ^ 2 > 0 →
      (x, y) ≠ (0, 0) →
      (a * x + b * y) ^ 2 + (a * c - b ^ 2) * y ^ 2 > 0 := by
    intro a b c x y ha hD hne
    by_cases hy : y = 0
    · have : x ≠ 0 := fun h => hne (Prod.ext h hy)
      subst hy; ring_nf; positivity
    · have : 0 < y ^ 2 := by positivity
      linarith [sq_nonneg (a * x + b * y), mul_pos hD this]
  constructor
  · -- Part 1: alternating sign minors → negative definite
    intro hf₁₁ hD₂ z₁ z₂ hne
    have hmul : 0 < f₁₁ * (f₁₁ * z₁ ^ 2 + 2 * f₁₂ * z₁ * z₂ + f₂₂ * z₂ ^ 2) := by
      linarith [rhs_pos hf₁₁.ne hD₂ hne,
        show f₁₁ * (f₁₁ * z₁ ^ 2 + 2 * f₁₂ * z₁ * z₂ + f₂₂ * z₂ ^ 2) =
          (f₁₁ * z₁ + f₁₂ * z₂) ^ 2 + (f₁₁ * f₂₂ - f₁₂ ^ 2) * z₂ ^ 2 from by ring]
    obtain ⟨h1, _⟩ | ⟨_, h2⟩ := mul_pos_iff.mp hmul
    · linarith
    · exact h2
  · -- Part 2: all positive minors → positive definite
    intro hf₁₁ hD₂ z₁ z₂ hne
    have hmul : 0 < f₁₁ * (f₁₁ * z₁ ^ 2 + 2 * f₁₂ * z₁ * z₂ + f₂₂ * z₂ ^ 2) := by
      linarith [rhs_pos hf₁₁.ne' hD₂ hne,
        show f₁₁ * (f₁₁ * z₁ ^ 2 + 2 * f₁₂ * z₁ * z₂ + f₂₂ * z₂ ^ 2) =
          (f₁₁ * z₁ + f₁₂ * z₂) ^ 2 + (f₁₁ * f₂₂ - f₁₂ ^ 2) * z₂ ^ 2 from by ring]
    obtain ⟨_, h1⟩ | ⟨h2, _⟩ := mul_pos_iff.mp hmul
    · exact h1
    · linarith