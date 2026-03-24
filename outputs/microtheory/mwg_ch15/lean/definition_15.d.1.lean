import Mathlib

/-- Factor input coefficients: `a ℓ j w` is the cost-minimizing input of factor `ℓ`
    per unit output of good `j` at factor prices `w`. -/
structure FactorIntensity where
  /-- Cost-minimizing input of factor ℓ per unit output of good j at factor prices w -/
  a : Fin 2 → Fin 2 → (Fin 2 → ℝ) → ℝ
  /-- All input coefficients are positive -/
  a_pos : ∀ ℓ j w, 0 < a ℓ j w
  /-- Good 0 is relatively more intensive in factor 0 than good 1:
      a₁₁(w)/a₂₁(w) > a₁₂(w)/a₂₂(w) for all factor prices w = (w₁, w₂) -/
  intensive : ∀ w : Fin 2 → ℝ, a 0 0 w / a 1 0 w > a 0 1 w / a 1 1 w