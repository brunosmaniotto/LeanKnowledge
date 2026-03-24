import Mathlib

open Finset BigOperators Topology Set
open scoped Real -- For `Real.rpow` (real power)
open Topology
open BigOperators

-- The non-negative orthant ℝⁿ₊
def nnOrthant (n : ℕ) : Set (Fin n → ℝ) :=
  {x | ∀ i, 0 ≤ x i}

-- Define Cobb-Douglas utility function on ℝⁿ₊
-- `hα` ensures that exponents are positive.
noncomputable def CobbDouglasUtility {n : ℕ} (α : Fin n → ℝ) (hα : ∀ i, 0 < α i) (x : Fin n → ℝ) : ℝ :=
  ∏ i, (x i) ^ (α i)

-- A function f : ℝⁿ → ℝ is strongly increasing if whenever y ≥ x componentwise
-- and y is strictly greater in at least one component, then f(x) < f(y).