import Mathlib

open Set

variable {E : Type*} [AddCommMonoid E] [Module ℝ E]

def IsQuasiconcaveOn (f : E → ℝ) (D : Set E) : Prop :=
  Convex ℝ D ∧ ∀ x₁ ∈ D, ∀ x₂ ∈ D, ∀ t : ℝ, 0 ≤ t → t ≤ 1 →
    min (f x₁) (f x₂) ≤ f (t • x₁ + (1 - t) • x₂)