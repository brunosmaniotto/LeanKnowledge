import Mathlib
open Topology

theorem Claim_3_2_c
    {n : ℕ} {A : Set (Fin n → ℝ)} (hA : Convex ℝ A)
    (f : (Fin n → ℝ) → ℝ)
    (hf : ∀ x ∈ A, ∀ y ∈ A, x ≠ y → ∀ t : ℝ, 0 < t → t < 1 →
      f (t • x + (1 - t) • y) > min (f x) (f y))
    (x₁ x₂ : Fin n → ℝ) (hx₁ : x₁ ∈ A) (hx₂ : x₂ ∈ A)
    (hne : x₁ ≠ x₂) (t : ℝ) (ht0 : 0 < t) (ht1 : t < 1) :
    f (t • x₁ + (1 - t) • x₂) > min (f x₁) (f x₂) :=
  hf x₁ hx₁ x₂ hx₂ hne t ht0 ht1