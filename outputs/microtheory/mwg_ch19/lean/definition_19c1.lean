import Mathlib
open Topology
open BigOperators

/-- An Arrow-Debreu equilibrium for a contingent commodity economy with `I` consumers,
    `J` firms, and `L × S` contingent commodities. -/
structure ArrowDebreuEquilibrium
    (I : Type*) [Fintype I]
    (J : Type*) [Fintype J]
    (L : ℕ) (S : ℕ)
    (X : I → Set (Fin (L * S) → ℝ))
    (Y : J → Set (Fin (L * S) → ℝ))
    (pref : I → (Fin (L * S) → ℝ) → (Fin (L * S) → ℝ) → Prop)
    (ω : I → Fin (L * S) → ℝ)
    (θ : I → J → ℝ) where
  /-- Consumer allocation -/
  x : I → Fin (L * S) → ℝ
  /-- Firm production plan -/
  y : J → Fin (L * S) → ℝ
  /-- Contingent commodity price vector -/
  p : Fin (L * S) → ℝ
  /-- Each allocation is feasible -/
  x_feasible : ∀ i, x i ∈ X i
  /-- Each production plan is feasible -/
  y_feasible : ∀ j, y j ∈ Y j
  /-- (i) Profit maximization: each firm maximizes profit at prices p -/
  profit_max : ∀ j, ∀ yj ∈ Y j,
    ∑ k, p k * yj k ≤ ∑ k, p k * (y j) k
  /-- (ii) Utility maximization: each consumer's bundle is maximal for their
      preference in the budget set -/
  utility_max : ∀ i, ∀ xi ∈ X i,
    ∑ k, p k * xi k ≤ ∑ k, p k * (ω i) k + ∑ j, θ i j * ∑ k, p k * (y j) k →
    ¬ pref i xi (x i)
  /-- (iii) Market clearing -/
  market_clear : ∀ k,
    ∑ i, (x i) k = ∑ j, (y j) k + ∑ i, (ω i) k