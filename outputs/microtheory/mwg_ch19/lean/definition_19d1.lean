import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- A Radner equilibrium for sequential trade with S states, L goods, and I consumers. -/
structure RadnerEquilibrium
    (S : ℕ) (L : ℕ) (I : ℕ)
    (ω : Fin I → Fin S → Fin L → ℝ)
    (utility : Fin I → (Fin S → ℝ) → (Fin S → Fin L → ℝ) → ℝ)
    (budgetFeasible : Fin I → (Fin S → ℝ) → (Fin S → Fin L → ℝ) →
      (Fin S → ℝ) → (Fin S → Fin L → ℝ) → Prop) where
  q : Fin S → ℝ
  p : Fin S → Fin L → ℝ
  z : Fin I → Fin S → ℝ
  x : Fin I → Fin S → Fin L → ℝ
  optimality : ∀ i : Fin I,
    budgetFeasible i (z i) (x i) q p ∧
    ∀ z' : Fin S → ℝ, ∀ x' : Fin S → Fin L → ℝ,
      budgetFeasible i z' x' q p →
      utility i z' x' ≤ utility i (z i) (x i)
  assetMarketClearing : ∀ s : Fin S,
    ∑ i : Fin I, z i s ≤ 0
  spotMarketClearing : ∀ s : Fin S, ∀ l : Fin L,
    ∑ i : Fin I, x i s l ≤ ∑ i : Fin I, ω i s l