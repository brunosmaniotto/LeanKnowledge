import Mathlib

/-- The Monotone Likelihood Ratio Property (MLRP).
Given two density functions `f_H` and `f_L` over profit levels (representing
the distribution of profits under high and low effort respectively), MLRP holds
when the likelihood ratio f_L(π)/f_H(π) is decreasing in π — equivalently,
for any π₁ < π₂, f_L(π₁) * f_H(π₂) ≥ f_L(π₂) * f_H(π₁). -/
structure MLRP (f_H f_L : ℝ → ℝ) : Prop where
  ratio_decreasing : ∀ π₁ π₂ : ℝ, π₁ < π₂ →
    f_L π₁ * f_H π₂ ≥ f_L π₂ * f_H π₁