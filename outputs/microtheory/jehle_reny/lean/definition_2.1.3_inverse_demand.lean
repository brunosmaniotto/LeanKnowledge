import Mathlib

open BigOperators Finset
open Topology

/-- The inverse demand function for an economy with `n` commodities.
    Given direct utility `u` and indirect utility `v`, the inverse demand
    function `p` maps quantity bundles `x` to normalised price vectors `p(x)`
    satisfying `u(x) = v(p(x), 1)` and `p(x) · x = 1`. -/
structure InverseDemandFunction (n : ℕ) where
  /-- Direct utility function over commodity bundles -/
  u : (Fin n → ℝ) → ℝ
  /-- Indirect utility function over prices and wealth -/
  v : (Fin n → ℝ) → ℝ → ℝ
  /-- The inverse demand function: maps quantity bundles to price vectors -/
  p : (Fin n → ℝ) → (Fin n → ℝ)
  /-- Defining identity: u(x) = v(p(x), 1) -/
  utility_eq : ∀ x : Fin n → ℝ, u x = v (p x) 1
  /-- Budget normalisation: p(x) · x = 1 -/
  budget_eq : ∀ x : Fin n → ℝ, ∑ i : Fin n, p x i * x i = 1