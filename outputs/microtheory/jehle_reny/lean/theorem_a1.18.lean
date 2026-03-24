import Mathlib

open Set
open Topology

theorem theorem_A1_18
    {D : Set ℝ} (hD : Convex ℝ D)
    (f : ℝ → ℝ) :
    (∀ y : ℝ, Convex ℝ {x ∈ D | f x ≤ y}) ↔
    (∀ x₁ x₂ : ℝ, x₁ ∈ D → x₂ ∈ D → ∀ t : ℝ, 0 ≤ t → t ≤ 1 →
      f (t * x₁ + (1 - t) * x₂) ≤ max (f x₁) (f x₂)) := by
  constructor
  · intro hconv x₁ x₂ hx₁ hx₂ t ht0 ht1
    set y := max (f x₁) (f x₂)
    have hx₁y : x₁ ∈ {x ∈ D | f x ≤ y} := ⟨hx₁, le_max_left _ _⟩
    have hx₂y : x₂ ∈ {x ∈ D | f x ≤ y} := ⟨hx₂, le_max_right _ _⟩
    have h1t : 0 ≤ 1 - t := by linarith
    have hsum : t + (1 - t) = 1 := by ring
    have hmem := hconv y hx₁y hx₂y ht0 h1t hsum
    exact hmem.2
  · intro hqc y
    intro x₁ hx₁ x₂ hx₂ t s ht hs hts
    constructor
    · exact hD hx₁.1 hx₂.1 ht hs hts
    · have hs_eq : s = 1 - t := by linarith
      rw [hs_eq]
      exact le_trans (hqc x₁ x₂ hx₁.1 hx₂.1 t ht (by linarith)) (max_le hx₁.2 hx₂.2)