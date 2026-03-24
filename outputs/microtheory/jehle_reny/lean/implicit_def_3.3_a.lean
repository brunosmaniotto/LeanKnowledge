import Mathlib

open scoped BigOperators
open Finset
open Topology
open BigOperators

noncomputable section

variable {n : ℕ}

/-- The conditional input demand `x(w, y)` is the solution to the cost
    minimization problem: the input vector `z ≥ 0` that minimizes total
    cost `w · z` subject to producing at least `y` units of output under
    production function `f`. It is conditional on the output level `y`. -/
noncomputable def conditionalInputDemand (f : (Fin n → ℝ) → ℝ)
    (w : Fin n → ℝ) (y : ℝ) : Fin n → ℝ :=
  Classical.epsilon fun z =>
    (∀ i, 0 ≤ z i) ∧ y ≤ f z ∧
    ∀ z', (∀ i, 0 ≤ z' i) → y ≤ f z' →
      ∑ i ∈ univ, w i * z i ≤ ∑ i ∈ univ, w i * z' i