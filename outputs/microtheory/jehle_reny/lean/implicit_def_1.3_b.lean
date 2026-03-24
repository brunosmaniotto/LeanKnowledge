import Mathlib

open BigOperators Finset
open Topology

/-- The budget set: all nonnegative consumption bundles affordable at prices `p` with income `y`.
    B(p, y) = {x ∈ ℝⁿ₊ | p · x ≤ y} where p ≫ 0 and y ≥ 0. -/
def budgetSet {n : ℕ} (p : Fin n → ℝ) (y : ℝ) : Set (Fin n → ℝ) :=
  {x | (∀ i, 0 ≤ x i) ∧ ∑ i, p i * x i ≤ y}