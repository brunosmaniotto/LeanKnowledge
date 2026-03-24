import Mathlib
open Topology

/-- A production function for a single-output technology with `n` inputs.
    Maps non-negative input vectors (z₁, ..., zₙ) to maximum output quantity. -/
structure ProductionFunction (n : ℕ) where
  /-- The function mapping input amounts to maximum output. -/
  toFun : (Fin n → ℝ) → ℝ

/-- The production set induced by a production function under free disposal of output:
    Y = {(-z₁, ..., -zₙ, q) : q ≤ f(z) and z ≥ 0}. -/
def ProductionFunction.productionSet {n : ℕ} (pf : ProductionFunction n) :
    Set (Fin (n + 1) → ℝ) :=
  {y | ∃ (z : Fin n → ℝ) (q : ℝ),
    (∀ i, 0 ≤ z i) ∧
    q ≤ pf.toFun z ∧
    (∀ i : Fin n, y (Fin.castSucc i) = -z i) ∧
    y (Fin.last n) = q}