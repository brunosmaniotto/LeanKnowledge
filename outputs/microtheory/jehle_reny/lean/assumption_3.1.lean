import Mathlib

open Set
open Topology

/-- The non-negative orthant ℝⁿ₊ -/
def nnOrthant (n : ℕ) : Set (Fin n → ℝ) :=
  {x | ∀ i, 0 ≤ x i}

/-- Assumption 3.1: Properties of the production function.
    f : ℝⁿ₊ → ℝ₊ is continuous, strictly increasing, strictly quasiconcave
    on ℝⁿ₊, and f(0) = 0. -/
structure Assumption_3_1 {n : ℕ} (f : (Fin n → ℝ) → ℝ) : Prop where
  cont : ContinuousOn f (nnOrthant n)
  nonneg : ∀ x ∈ nnOrthant n, 0 ≤ f x
  strict_increasing : ∀ x ∈ nnOrthant n, ∀ y ∈ nnOrthant n,
    (∀ i, y i ≤ x i) → x ≠ y → f y < f x
  strict_quasiconcave : ∀ x ∈ nnOrthant n, ∀ y ∈ nnOrthant n,
    x ≠ y → ∀ t : ℝ, 0 < t → t < 1 →
    f (fun i => t * x i + (1 - t) * y i) > min (f x) (f y)
  f_zero : f 0 = 0