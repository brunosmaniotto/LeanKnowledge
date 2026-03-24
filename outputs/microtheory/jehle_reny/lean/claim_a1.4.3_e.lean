import Mathlib

open Set

theorem claim_A1_4_3_e
    {V : Type*} [AddCommGroup V] [Module ℝ V]
    (f : V → ℝ)
    (hsqc : ∀ (x₁ x₂ : V), x₁ ≠ x₂ → f x₁ = f x₂ →
      ∀ (t : ℝ), 0 < t → t < 1 →
        f (t • x₁ + (1 - t) • x₂) > f x₁)
    (x₁ x₂ : V) (hne : x₁ ≠ x₂) (hlevel : f x₁ = f x₂)
    (t : ℝ) (ht0 : 0 < t) (ht1 : t < 1) :
    f (t • x₁ + (1 - t) • x₂) > min (f x₁) (f x₂) := by
  rw [hlevel, min_self]
  rw [← hlevel]
  exact hsqc x₁ x₂ hne hlevel t ht0 ht1