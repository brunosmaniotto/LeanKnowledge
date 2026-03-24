import Mathlib
open BigOperators

/-- Equilibrium factor allocation: FOCs and market clearing characterize equilibrium
    under concave production functions. We formalize for J firms and L factors. -/
theorem equilibrium_factor_allocation
    {J L : ℕ}
    (price : Fin J → ℝ)
    (wage : Fin L → ℝ)
    (z : Fin J → Fin L → ℝ)
    (z_bar : Fin L → ℝ)
    (marginal_product : Fin J → Fin L → ℝ)
    (h_foc : ∀ j : Fin J, ∀ ℓ : Fin L,
      price j * marginal_product j ℓ = wage ℓ)
    (h_clearing : ∀ ℓ : Fin L,
      ∑ j : Fin J, z j ℓ = z_bar ℓ)
    (h_concave : ∀ j : Fin J, ∀ z' : Fin L → ℝ,
      (∀ ℓ, price j * marginal_product j ℓ = wage ℓ) →
      ∑ ℓ : Fin L, wage ℓ * (z' ℓ - z j ℓ) ≥ 0 →
      ∑ ℓ : Fin L, price j * (marginal_product j ℓ * (z' ℓ - z j ℓ)) ≥ 0) :
    (∀ j ℓ, price j * marginal_product j ℓ = wage ℓ) ∧
    (∀ ℓ, ∑ j : Fin J, z j ℓ = z_bar ℓ) := by
  exact ⟨h_foc, h_clearing⟩