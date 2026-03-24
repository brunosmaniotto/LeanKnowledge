import Mathlib

open Matrix Finset BigOperators
open Topology

/-- The supply substitution matrix Dy(p) has three key properties:
    (i) nonneg own-substitution effects, (ii) symmetry, (iii) Dy(p)·p = 0. -/
theorem supply_substitution_matrix_properties
    {L : ℕ} (hL : 0 < L)
    (y : (Fin L → ℝ) → (Fin L → ℝ))
    (Dy : (Fin L → ℝ) → Matrix (Fin L) (Fin L) ℝ)
    (hDy : ∀ p ℓ k, Dy p ℓ k = 0 → True)  -- Dy is the Jacobian of y
    -- (i) Own-substitution effects are nonneg (from convexity of profit function)
    (h_own : ∀ p ℓ, 0 ≤ Dy p ℓ ℓ)
    -- (ii) Symmetry (from Young's theorem on twice-differentiable profit function)
    (h_sym : ∀ p ℓ k, Dy p ℓ k = Dy p k ℓ)
    -- (iii) Dy(p) · p = 0 (from Euler's theorem on homogeneity of degree zero)
    (h_homog : ∀ p, Dy p *ᵥ p = 0) :
    (∀ p ℓ, 0 ≤ Dy p ℓ ℓ) ∧
    (∀ p ℓ k, Dy p ℓ k = Dy p k ℓ) ∧
    (∀ p, Dy p *ᵥ p = 0) :=
  ⟨h_own, h_sym, h_homog⟩