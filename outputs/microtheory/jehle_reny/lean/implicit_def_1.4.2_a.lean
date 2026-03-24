import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- The Hicksian (compensated) demand correspondence h(p, ū) is the set of
    non-negative bundles that minimise expenditure p · x subject to u(x) ≥ ū.
    Named after Hicks (1939); "compensated" because income is hypothetically
    adjusted to keep the consumer on the same indifference curve. -/
noncomputable def hicksianDemand
    (n : ℕ)
    (u : (Fin n → ℝ) → ℝ)
    (p : Fin n → ℝ)
    (uBar : ℝ) : Set (Fin n → ℝ) :=
  {x : Fin n → ℝ |
    (∀ i, 0 ≤ x i) ∧
    u x ≥ uBar ∧
    (∀ y : Fin n → ℝ, (∀ i, 0 ≤ y i) → u y ≥ uBar →
      ∑ i : Fin n, p i * x i ≤ ∑ i : Fin n, p i * y i)}