import Mathlib

/-- The wealth effect vector D_w x(p, w) = (∂x₁/∂w, ..., ∂x_L/∂w)ᵀ ∈ ℝ^L.
    Given a demand function `x` mapping prices p ∈ ℝ^L and wealth w ∈ ℝ
    to a consumption bundle in ℝ^L, the wealth effect at (p, w) is the
    vector of partial derivatives of each demand component with respect
    to wealth. -/
noncomputable def wealthEffects (L : ℕ)
    (x : (Fin L → ℝ) → ℝ → (Fin L → ℝ))
    (p : Fin L → ℝ) (w : ℝ) : Fin L → ℝ :=
  fun ℓ => deriv (fun w' => x p w' ℓ) w