import Mathlib
open Set TopologicalSpace Filter Metric Bornology
open BigOperators Finset
open Pointwise -- For IsConvex
open Topology
open FiniteDimensional

variable {n : ℕ} (hn : n > 0)
variable {ε : ℝ} (hε : 0 < ε) (hε_lt_1 : ε < 1)

-- Define the set S_ε
def S_epsilon (n : ℕ) (ε : ℝ) : Set (Fin n → ℝ) :=
  { p | (∑ k : Fin n, p k = 1) ∧ (∀ k : Fin n, p k ≥ ε / (1 + (2 : ℝ) * n)) }

-- `Fin n → ℝ` is a finite-dimensional real vector space, which is a proper space.
-- These instances should be inferred by Mathlib.
-- `Pi.topologicalSpace` for `TopologicalSpace (Fin n → ℝ)`
-- `Pi.normedSpace` for `NormedSpace ℝ (Fin n → ℝ)`
-- `FiniteDimensional.pi` for `FiniteDimensional ℝ (Fin n → ℝ)`
-- `FiniteDimensional.properSpace` then gives `ProperSpace (Fin n → ℝ)`