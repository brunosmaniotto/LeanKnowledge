import Mathlib

open Finset BigOperators
open Topology
open BigOperators

theorem Exercise_7_7_b
    {S₁ S₂ : Type*} [Fintype S₁] [Fintype S₂] [DecidableEq S₁] [DecidableEq S₂]
    (u : S₁ → S₂ → ℝ)
    (p₁ q₁ : S₁ → ℝ) (p₂ q₂ : S₂ → ℝ)
    (hp₁ : ∀ s, 0 ≤ p₁ s) (hq₁ : ∀ s, 0 ≤ q₁ s)
    (hp₂ : ∀ s, 0 ≤ p₂ s) (hq₂ : ∀ s, 0 ≤ q₂ s)
    (EU : (S₁ → ℝ) → (S₂ → ℝ) → ℝ := fun m₁ m₂ =>
      ∑ s₁ : S₁, ∑ s₂ : S₂, m₁ s₁ * m₂ s₂ * u s₁ s₂)
    -- (p₁, p₂) is a Nash equilibrium
    (hNE1_1 : ∀ m₁ : S₁ → ℝ, (∀ s, 0 ≤ m₁ s) → EU m₁ p₂ ≤ EU p₁ p₂)
    (hNE1_2 : ∀ m₂ : S₂ → ℝ, (∀ s, 0 ≤ m₂ s) → EU p₁ p₂ ≤ EU p₁ m₂)
    -- (q₁, q₂) is a Nash equilibrium
    (hNE2_1 : ∀ m₁ : S₁ → ℝ, (∀ s, 0 ≤ m₁ s) → EU m₁ q₂ ≤ EU q₁ q₂)
    (hNE2_2 : ∀ m₂ : S₂ → ℝ, (∀ s, 0 ≤ m₂ s) → EU q₁ q₂ ≤ EU q₁ m₂) :
    -- (p₁, q₂) is also a Nash equilibrium
    (∀ m₁ : S₁ → ℝ, (∀ s, 0 ≤ m₁ s) → EU m₁ q₂ ≤ EU p₁ q₂) ∧
    (∀ m₂ : S₂ → ℝ, (∀ s, 0 ≤ m₂ s) → EU p₁ q₂ ≤ EU p₁ m₂) := by
  -- Establish chain of inequalities
  have h1 : EU q₁ p₂ ≤ EU p₁ p₂ := hNE1_1 q₁ hq₁
  have h2 : EU q₁ q₂ ≤ EU q₁ p₂ := by have := hNE2_2 p₂ hp₂; linarith
  have h3 : EU p₁ q₂ ≤ EU q₁ q₂ := hNE2_1 p₁ hp₁
  have h4 : EU p₁ p₂ ≤ EU p₁ q₂ := hNE1_2 q₂ hq₂
  -- All are equal
  have heq1 : EU p₁ q₂ = EU q₁ q₂ := by linarith
  have heq2 : EU p₁ p₂ = EU p₁ q₂ := by linarith
  constructor
  · intro m₁ hm₁
    have := hNE2_1 m₁ hm₁
    linarith
  · intro m₂ hm₂
    have := hNE1_2 m₂ hm₂
    linarith