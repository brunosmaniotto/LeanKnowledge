import Mathlib

open Set
open Topology

/-- Strictly quasiconvex functions have no linear segments in their level sets:
    if f(x₁) = f(x₂) and x₁ ≠ x₂, then f(t·x₁ + (1-t)·x₂) < f(x₁) for t ∈ (0,1). -/
theorem claim_A1_4_4_h
    {f : ℝ → ℝ}
    (hf : ∀ (x₁ x₂ : ℝ), x₁ ≠ x₂ →
      ∀ (t : ℝ), 0 < t → t < 1 →
        f (t * x₁ + (1 - t) * x₂) < max (f x₁) (f x₂))
    (x₁ x₂ : ℝ) (hne : x₁ ≠ x₂)
    (heq : f x₁ = f x₂)
    (t : ℝ) (ht0 : 0 < t) (ht1 : t < 1) :
    f (t * x₁ + (1 - t) * x₂) < f x₁ := by
  have h := hf x₁ x₂ hne t ht0 ht1
  rw [heq, max_self] at h
  linarith