import Mathlib

noncomputable section

variable {L : ℕ}

/-- The compensating variation (CV) for a price change from p₀ to p₁
    at initial income y₀ (Jehle & Reny, Definition 4.3.1).
    Defined implicitly by v(p₁, y₀ + CV) = v(p₀, y₀), equivalently
    CV = e(p₁, v(p₀, y₀)) − y₀, where e is the expenditure function
    and v is the indirect utility function. -/
noncomputable def compensatingVariation
    (e : (Fin L → ℝ) → ℝ → ℝ)   -- expenditure function e(p, u)
    (v : (Fin L → ℝ) → ℝ → ℝ)   -- indirect utility function v(p, y)
    (p₀ p₁ : Fin L → ℝ)          -- old and new price vectors
    (y₀ : ℝ)                      -- initial income
    : ℝ :=
  e p₁ (v p₀ y₀) - y₀