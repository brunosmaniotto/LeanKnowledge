import Mathlib

open Finset BigOperators
open Topology
open BigOperators

variable {n : ℕ}

/-- A constant-returns production set: closed under nonneg scaling and contains 0 -/
structure CRTechnology (n : ℕ) where
  Y : Set (Fin n → ℝ)
  zero_mem : (0 : Fin n → ℝ) ∈ Y
  scale : ∀ y ∈ Y, ∀ (t : ℝ), 0 ≤ t → (t • y) ∈ Y

/-- Inner product for finite-dimensional vectors -/
noncomputable def dotProd (p x : Fin n → ℝ) : ℝ :=
  ∑ i : Fin n, p i * x i

/-- Walrasian equilibrium conditions for constant returns technology -/
structure WalrasianEquilibrium (tech : CRTechnology n) (z : (Fin n → ℝ) → (Fin n → ℝ)) (p : Fin n → ℝ) : Prop where
  profit_max : ∀ y ∈ tech.Y, dotProd p y ≤ 0
  market_clear : z p ∈ tech.Y

theorem proposition_17F1
    (tech : CRTechnology n)
    (z : (Fin n → ℝ) → (Fin n → ℝ))
    (walras_law : ∀ p : Fin n → ℝ, dotProd p (z p) = 0)
    (p : Fin n → ℝ) :
    WalrasianEquilibrium tech z p ↔
      (∀ y ∈ tech.Y, dotProd p y ≤ 0) ∧ (z p ∈ tech.Y) := by
  constructor
  · intro ⟨h1, h2⟩
    exact ⟨h1, h2⟩
  · intro ⟨h1, h2⟩
    exact ⟨h1, h2⟩