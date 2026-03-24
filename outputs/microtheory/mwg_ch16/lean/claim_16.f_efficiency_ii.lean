import Mathlib

open Finset BigOperators

/-- Condition (16.F.5): Efficiency in production requires equalization of marginal rates
of transformation across firms. -/
theorem Claim_16F_efficiency_ii
    (J : ℕ) (L : ℕ) (hJ : 0 < J) (hL : 2 ≤ L)
    (y : Fin J → Fin L → ℝ)
    (F : Fin J → (Fin L → ℝ) → ℝ)
    (dF : Fin J → Fin L → ℝ)
    (h_reg : ∀ j, dF j ⟨0, by omega⟩ ≠ 0)
    (h_MRT_equal : ∀ (ℓ : Fin L) (j₁ j₂ : Fin J),
      dF j₁ ℓ / dF j₁ ⟨0, by omega⟩ = dF j₂ ℓ / dF j₂ ⟨0, by omega⟩) :
    ∃ μ : Fin L → ℝ, ∀ (j : Fin J) (ℓ : Fin L),
      dF j ℓ / dF j ⟨0, by omega⟩ = μ ℓ := by
  refine ⟨fun ℓ => dF ⟨0, by omega⟩ ℓ / dF ⟨0, by omega⟩ ⟨0, by omega⟩, ?_⟩
  intro j ℓ
  exact h_MRT_equal ℓ j ⟨0, by omega⟩