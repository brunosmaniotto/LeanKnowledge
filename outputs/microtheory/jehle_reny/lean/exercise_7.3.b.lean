import Mathlib

open Set
open Topology

/-- In a finite game, the order of elimination does not matter when eliminating
    strictly dominated strategies. Two different elimination orders produce the
    same surviving set at every round, hence the same final result. -/
theorem iesds_order_independent
    {α : Type*} (S : Set α)
    (step₁ step₂ : Set α → Set α)
    (h_mono₁ : Monotone step₁)
    (h_mono₂ : Monotone step₂)
    (h₁₂ : ∀ T, step₁ T ⊆ step₂ T)
    (h₂₁ : ∀ T, step₂ T ⊆ step₁ T)
    (n : ℕ) :
    (step₁^[n]) S = (step₂^[n]) S := by
  induction n with
  | zero => simp
  | succ n ih =>
    simp only [Function.iterate_succ', Function.comp]
    apply Subset.antisymm
    · calc step₁ ((step₁^[n]) S)
          ⊆ step₁ ((step₂^[n]) S) := h_mono₁ (ih ▸ le_refl _)
        _ ⊆ step₂ ((step₂^[n]) S) := h₁₂ _
    · calc step₂ ((step₂^[n]) S)
          ⊆ step₂ ((step₁^[n]) S) := h_mono₂ (ih ▸ le_refl _)
        _ ⊆ step₁ ((step₁^[n]) S) := h₂₁ _