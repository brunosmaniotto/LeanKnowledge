import Mathlib
open Topology

/-- A production function for a single-output technology with `n` inputs.
    Maps non-negative input vectors x ∈ ℝⁿ₊ to non-negative output y ∈ ℝ₊.
    `f(x)` gives the maximum amount of output producible from input vector `x`. -/
structure ProductionFunction (n : ℕ) where
  /-- The underlying function from input vectors to output quantity. -/
  toFun : (Fin n → ℝ) → ℝ
  /-- Output is non-negative whenever all inputs are non-negative. -/
  nonneg : ∀ x : Fin n → ℝ, (∀ i, 0 ≤ x i) → 0 ≤ toFun x

instance {n : ℕ} : CoeFun (ProductionFunction n) fun _ => (Fin n → ℝ) → ℝ :=
  ⟨ProductionFunction.toFun⟩