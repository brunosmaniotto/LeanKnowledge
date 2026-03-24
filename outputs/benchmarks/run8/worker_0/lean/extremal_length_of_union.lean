import Mathlib

open Set
open ENNReal

structure ExtremalLengthData (X : Type) where
  Metric : Type
  length : Set (Set X) → Metric → ℝ≥0∞
  area : Metric → ℝ≥0∞
  length_nonneg : ∀ Γ ρ, 0 ≤ length Γ ρ
  area_nonneg : ∀ ρ, 0 ≤ area ρ
  max_metric : Metric → Metric → Metric
  length_max_ge : ∀ Γ₁ Γ₂ ρ₁ ρ₂, length Γ₁ ρ₁ ≥ 1 → length Γ₂ ρ₂ ≥ 1 → length (Γ₁ ∪ Γ₂) (max_metric ρ₁ ρ₂) ≥ 1
  area_max_le : ∀ ρ₁ ρ₂, area (max_metric ρ₁ ρ₂) ≤ area ρ₁ + area ρ₂
  restrict : Metric → Set X → Metric
  restrict_area_add : ∀ ρ A B, Disjoint A B → area ρ = area (restrict ρ A) + area (restrict ρ B)
  restrict_length_eq : ∀ Γ ρ A, (∀ γ ∈ Γ, γ ⊆ A) → length Γ (restrict ρ A) = length Γ ρ

namespace ExtremalLengthData

variable {X : Type} (E : ExtremalLengthData X)

noncomputable def modulus (Γ : Set (Set X)) : ℝ≥0∞ :=
  ⨅ (ρ : E.Metric), ⨅ (_ : E.length Γ ρ ≥ 1), E.area ρ

theorem modulus_union_le (Γ₁ Γ₂ : Set (Set X)) :
    1 / E.modulus (Γ₁ ∪ Γ₂) ≤ 1 / E.modulus Γ₁ + 1 / E.modulus Γ₂ := by
  by_cases h1 : E.modulus Γ₁ = 0
  · simp [h1]
  by_cases h2 : E.modulus Γ₂ = 0
  · simp [h2]
  by_cases h3 : E.modulus (Γ₁ ∪ Γ₂) = ∞
  · simp [h3]
  sorry