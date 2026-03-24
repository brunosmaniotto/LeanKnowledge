import Mathlib

open Finset BigOperators
open BigOperators

/-- A competitive (Walrasian) equilibrium for an economy with `I` consumers,
    `J` firms, and `L` goods. -/
structure CompetitiveEquilibrium
    (L : ℕ) (I : ℕ) (J : ℕ)
    (X : Fin I → Set (Fin L → ℝ))        -- consumption sets
    (Y : Fin J → Set (Fin L → ℝ))        -- production sets
    (u : Fin I → (Fin L → ℝ) → ℝ)        -- utility functions
    (ω : Fin I → Fin L → ℝ)              -- endowments
    (θ : Fin I → Fin J → ℝ)              -- ownership shares
    where
  /-- Equilibrium consumption bundles -/
  x : Fin I → Fin L → ℝ
  /-- Equilibrium production plans -/
  y : Fin J → Fin L → ℝ
  /-- Equilibrium price vector -/
  p : Fin L → ℝ
  /-- Each consumption bundle is feasible -/
  x_mem : ∀ i, x i ∈ X i
  /-- Each production plan is feasible -/
  y_mem : ∀ j, y j ∈ Y j
  /-- Profit maximization: for each firm j, y j maximizes p · y over Y j -/
  profit_max : ∀ j, ∀ yj ∈ Y j,
    ∑ ℓ, p ℓ * yj ℓ ≤ ∑ ℓ, p ℓ * y j ℓ
  /-- Utility maximization: for each consumer i, x i maximizes u i
      over budget-feasible bundles in X i -/
  utility_max : ∀ i, ∀ xi ∈ X i,
    ∑ ℓ, p ℓ * xi ℓ ≤ ∑ ℓ, p ℓ * (ω i ℓ) + ∑ j, θ i j * ∑ ℓ, p ℓ * y j ℓ →
    u i xi ≤ u i (x i)
  /-- Budget feasibility of the equilibrium bundle -/
  budget : ∀ i,
    ∑ ℓ, p ℓ * x i ℓ ≤ ∑ ℓ, p ℓ * (ω i ℓ) + ∑ j, θ i j * ∑ ℓ, p ℓ * y j ℓ
  /-- Market clearing: total consumption = total endowment + total production -/
  market_clear : ∀ ℓ : Fin L,
    ∑ i, x i ℓ = ∑ i, ω i ℓ + ∑ j, y j ℓ