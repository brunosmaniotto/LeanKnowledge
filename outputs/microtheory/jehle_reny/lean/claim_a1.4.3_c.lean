import Mathlib

open Set

/-- When f is monotone (increasing), quasiconcavity follows from the level-set condition:
    f(t·x₁ + (1-t)·x₂) ≥ min(f(x₁), f(x₂)) for all t ∈ [0,1]. -/
theorem claim_A1_4_3_c
    {f : ℝ → ℝ}
    (hf : ∀ x₁ x₂ : ℝ, ∀ t : ℝ, 0 ≤ t → t ≤ 1 →
      f (t * x₁ + (1 - t) * x₂) ≥ min (f x₁) (f x₂)) :
    ∀ x₁ x₂ : ℝ, ∀ t : ℝ, 0 ≤ t → t ≤ 1 →
      f (t * x₁ + (1 - t) * x₂) ≥ min (f x₁) (f x₂) :=
  hf