import Mathlib
open Topology

/-- A two-period monopoly maximizing PDV = π₀ + δ·π₁ (where δ = 1/(1+r) > 0)
    with separable per-period profits decomposes into independent per-period
    profit maximization problems. -/
theorem Exercise_4_29_a
    (π₀ π₁ : ℝ → ℝ) (δ : ℝ) (q₀ q₁ : ℝ)
    (hδ : δ > 0)
    (hmax : ∀ q₀' q₁' : ℝ, π₀ q₀' + δ * π₁ q₁' ≤ π₀ q₀ + δ * π₁ q₁) :
    (∀ q₀' : ℝ, π₀ q₀' ≤ π₀ q₀) ∧ (∀ q₁' : ℝ, π₁ q₁' ≤ π₁ q₁) := by
  constructor
  · intro q₀'
    have h := hmax q₀' q₁
    linarith
  · intro q₁'
    by_contra h_neg
    push_neg at h_neg
    have h := hmax q₀ q₁'
    nlinarith