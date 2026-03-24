import Mathlib
open Topology

/-- A function f : ℝⁿ → ℝ is strongly increasing if whenever y ≥ x componentwise
    and y is strictly greater in at least one component, then f(x) < f(y). -/
def IsStronglyIncreasing {n : ℕ} (f : (Fin n → ℝ) → ℝ) : Prop :=
  ∀ x y : Fin n → ℝ, (∀ i, x i ≤ y i) → (∃ j, x j < y j) → f x < f y