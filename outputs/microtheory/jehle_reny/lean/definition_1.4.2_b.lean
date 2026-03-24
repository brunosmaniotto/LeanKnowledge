import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- The set of attainable utility levels: U = {u(x) | x ∈ ℝⁿ₊}. -/
def attainableUtilityLevels (n : ℕ) (u : (Fin n → ℝ) → ℝ) : Set ℝ :=
  {v : ℝ | ∃ x : Fin n → ℝ, (∀ i, 0 ≤ x i) ∧ v = u x}

/-- The expenditure function e(p, ū) = min {p · x : x ∈ ℝⁿ₊, u(x) ≥ ū}.
    Defined as the infimum of expenditure p · x over all nonnegative bundles x
    achieving at least utility level ū. -/
noncomputable def expenditure (n : ℕ) (p : Fin n → ℝ) (u : (Fin n → ℝ) → ℝ)
    (ubar : ℝ) : ℝ :=
  sInf {e : ℝ | ∃ x : Fin n → ℝ, (∀ i, 0 ≤ x i) ∧ ubar ≤ u x ∧ e = ∑ i, p i * x i}