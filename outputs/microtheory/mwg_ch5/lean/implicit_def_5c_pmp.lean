import Mathlib

open scoped BigOperators
open Topology
open BigOperators

/-- The profit maximization problem (PMP) over a production set Y:
    sup {p · y | y ∈ Y}. Returns the supremum of profit over feasible plans. -/
noncomputable def profitMaximization {n : ℕ} (p : Fin n → ℝ) (Y : Set (Fin n → ℝ)) : ℝ :=
  ⨆ y ∈ Y, ∑ i, p i * y i

/-- The profit maximization problem (PMP) using a transformation function F:
    sup {p · y | F(y) ≤ 0}. Equivalent formulation where the production set
    is described implicitly as {y | F(y) ≤ 0}. -/
noncomputable def profitMaximizationPMP {n : ℕ} (p : Fin n → ℝ)
    (F : (Fin n → ℝ) → ℝ) : ℝ :=
  ⨆ y ∈ {y | F y ≤ 0}, ∑ i, p i * y i