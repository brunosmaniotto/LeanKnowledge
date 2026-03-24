import Mathlib

open BigOperators Finset
open Topology

/-- A Cournot-Nash equilibrium: a vector of outputs where each firm maximizes
    profit given the other firms' outputs. -/
structure CournotNashEquilibrium (J : Type*) [Fintype J] [DecidableEq J]
    (cost : J → ℝ → ℝ) (P : ℝ → ℝ) where
  /-- The equilibrium output vector -/
  q : J → ℝ
  /-- Each firm's output is nonneg -/
  q_nonneg : ∀ j, 0 ≤ q j
  /-- Each firm maximizes profit: no deviation is profitable -/
  is_nash : ∀ j : J, ∀ q_j' : ℝ, 0 ≤ q_j' →
    let totalOutput := ∑ i ∈ Finset.univ, q i
    let totalOutput' := totalOutput - q j + q_j'
    P totalOutput * q j - cost j (q j) ≥ P totalOutput' * q_j' - cost j q_j'