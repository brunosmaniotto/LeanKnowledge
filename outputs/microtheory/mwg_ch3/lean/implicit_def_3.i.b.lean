import Mathlib

noncomputable def equivalentVariation
    (e : (Fin L → ℝ) → ℝ → ℝ)   -- expenditure function e(p, u)
    (v : (Fin L → ℝ) → ℝ → ℝ)   -- indirect utility function v(p, w)
    (p₀ p₁ : Fin L → ℝ)          -- price vectors
    (w : ℝ)                        -- wealth
    : ℝ :=
  e p₀ (v p₁ w) - w