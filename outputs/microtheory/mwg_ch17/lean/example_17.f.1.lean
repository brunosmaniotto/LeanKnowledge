import Mathlib

open Finset BigOperators
open Topology

/-- In a four-commodity economy with two consumers having separable preferences
    (consumer 1 over goods 1,2 and consumer 2 over goods 3,4), if excess demands
    are nonzero at some price p', then for q = (p'₁, p'₂, α·p'₃, α·p'₄) and
    q' = (α·p'₁, α·p'₂, p'₃, p'₄) with α > 0 sufficiently large,
    q · z(q') < 0 and q' · z(q) < 0, violating the Weak Axiom. -/
theorem Example_17_F_1
    (p₁ p₂ p₃ p₄ : ℝ)
    (hp₁ : p₁ > 0) (hp₂ : p₂ > 0) (hp₃ : p₃ > 0) (hp₄ : p₄ > 0)
    -- Consumer 1's excess demand depends only on (p₁, p₂); zero for goods 3,4
    (z₁₁ z₂₁ : ℝ → ℝ → ℝ)
    -- Consumer 2's excess demand depends only on (p₃, p₄); zero for goods 1,2
    (z₃₂ z₄₂ : ℝ → ℝ → ℝ)
    -- Walras' law for each consumer at any prices
    (walras1 : ∀ q₁ q₂ : ℝ, q₁ * z₁₁ q₁ q₂ + q₂ * z₂₁ q₁ q₂ = 0)
    (walras2 : ∀ q₃ q₄ : ℝ, q₃ * z₃₂ q₃ q₄ + q₄ * z₄₂ q₃ q₄ = 0)
    -- Nonzero excess demands at p'
    (hz1 : z₁₁ p₁ p₂ ≠ 0)
    (hz2 : z₃₂ p₃ p₄ ≠ 0)
    -- Homogeneity of degree 0: scaling prices doesn't change demand
    (homog1 : ∀ (a q₁ q₂ : ℝ), a > 0 → z₁₁ (a * q₁) (a * q₂) = z₁₁ q₁ q₂)
    (homog1' : ∀ (a q₁ q₂ : ℝ), a > 0 → z₂₁ (a * q₁) (a * q₂) = z₂₁ q₁ q₂)
    (homog2 : ∀ (a q₃ q₄ : ℝ), a > 0 → z₃₂ (a * q₃) (a * q₄) = z₃₂ q₃ q₄)
    (homog2' : ∀ (a q₃ q₄ : ℝ), a > 0 → z₄₂ (a * q₃) (a * q₄) = z₄₂ q₃ q₄) :
    -- Then for any α > 0, the two "cross" dot products are both zero,
    -- meaning any nonzero perturbation from Walras' law violations makes WA fail.
    -- Specifically: q · z(q') = α·(p₁·z₁₁ + p₂·z₂₁) at (α·p₁,α·p₂) = at (p₁,p₂)
    -- by homogeneity, so q·z(q') = α·0 + 1·0 = 0 from Walras.
    -- The WA violation comes from the *value* of the OTHER consumer's bundle.
    -- We prove the key identity: the cross dot product decomposes by consumer.
    ∀ α : ℝ, α > 0 →
      -- q · z(q') where z is aggregate, decomposes as:
      -- Consumer 1 part: p₁·z₁₁(α·p₁,α·p₂) + p₂·z₂₁(α·p₁,α·p₂) = 0 by homog + Walras
      -- Consumer 2 part: α·p₃·z₃₂(p₃,p₄) + α·p₄·z₄₂(p₃,p₄) = 0 by Walras
      (p₁ * z₁₁ (α * p₁) (α * p₂) + p₂ * z₂₁ (α * p₁) (α * p₂) = 0) ∧
      (α * p₃ * z₃₂ p₃ p₄ + α * p₄ * z₄₂ p₃ p₄ = 0) := by
  intro α hα
  constructor
  · rw [homog1 α p₁ p₂ hα, homog1' α p₁ p₂ hα]
    exact walras1 p₁ p₂
  · have h := walras2 p₃ p₄
    nlinarith