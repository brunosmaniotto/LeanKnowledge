import Mathlib

open Finset BigOperators
open Topology

theorem utility_possibility_set_convex
    {n : ℕ}
    {E : Type*} [AddCommMonoid E] [Module ℝ E]
    (S : Set E)
    (u : Fin n → E → ℝ)
    (hS : Convex ℝ S)
    (hu_concave : ∀ i, ConcaveOn ℝ S (u i)) :
    Convex ℝ { v : Fin n → ℝ | ∃ x ∈ S, ∀ i, v i ≤ u i x } := by
  intro v₁ ⟨x₁, hx₁S, hv₁_le⟩ v₂ ⟨x₂, hx₂S, hv₂_le⟩ a b ha hb hab
  refine ⟨a • x₁ + b • x₂, hS hx₁S hx₂S ha hb hab, fun i => ?_⟩
  calc (a • v₁ + b • v₂) i
      = a * v₁ i + b * v₂ i := by simp [Pi.add_apply, Pi.smul_apply, smul_eq_mul]
    _ ≤ a * u i x₁ + b * u i x₂ := by
        exact add_le_add (mul_le_mul_of_nonneg_left (hv₁_le i) ha)
          (mul_le_mul_of_nonneg_left (hv₂_le i) hb)
    _ ≤ u i (a • x₁ + b • x₂) :=
        (hu_concave i).2 hx₁S hx₂S ha hb hab