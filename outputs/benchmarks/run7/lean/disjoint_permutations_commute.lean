import Mathlib.GroupTheory.Perm.Basic

open Equiv

theorem disjoint_permutations_commute {α : Type*} (σ τ : Perm α) 
    (h : ∀ x, σ x = x ∨ τ x = x) : σ * τ = τ * σ := by
  ext x
  rcases h x with (hσx | hτx)
  · -- Case where σ fixes x
    rcases h (τ x) with (hσy | hτy)
    · -- Case where σ fixes τ x
      simp [hσx, hσy]
    · -- Case where τ fixes τ x
      have H : τ x = x := τ.injective hτy
      simp [hσx, H]
  · -- Case where τ fixes x
    rcases h (σ x) with (hσy | hτy)
    · -- Case where σ fixes σ x
      have H : σ x = x := σ.injective hσy
      simp [hτx, H]
    · -- Case where τ fixes σ x
      simp [hτx, hτy]