import Mathlib
open Topology

theorem Theorem_A2_3 {n : ℕ} {D : Set (Fin n → ℝ)} {f : (Fin n → ℝ) → ℝ}
    (hD : Convex ℝ D) (hf : ConcaveOn ℝ D f)
    (x : Fin n → ℝ) (z : Fin n → ℝ) :
    let C := {t : ℝ | x + t • z ∈ D}
    let g := fun t : ℝ => f (x + t • z)
    ConcaveOn ℝ C g := by
  intro C g
  have key : ∀ a b t₀ t₁ : ℝ, a + b = 1 →
      x + (a * t₀ + b * t₁) • z = a • (x + t₀ • z) + b • (x + t₁ • z) := by
    intro a b t₀ t₁ hab
    have hx : x = (a + b) • x := by rw [hab, one_smul]
    conv_lhs => rw [hx]
    module
  constructor
  · -- C is convex
    intro t₀ ht₀ t₁ ht₁ a b ha hb hab
    show x + (a * t₀ + b * t₁) • z ∈ D
    rw [key a b t₀ t₁ hab]
    exact hD ht₀ ht₁ ha hb hab
  · -- g is concave on C
    intro t₀ ht₀ t₁ ht₁ a b ha hb hab
    show a * f (x + t₀ • z) + b * f (x + t₁ • z) ≤ f (x + (a * t₀ + b * t₁) • z)
    rw [key a b t₀ t₁ hab]
    exact hf.2 ht₀ ht₁ ha hb hab