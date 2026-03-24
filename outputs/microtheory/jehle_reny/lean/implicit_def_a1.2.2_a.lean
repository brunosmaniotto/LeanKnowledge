import Mathlib

/-- A point `z` is a convex combination of `x₁` and `x₂` if
    `z = t • x₁ + (1 - t) • x₂` for some `t ∈ [0, 1]`. -/
def IsConvexCombination {V : Type*} [AddCommMonoid V] [Module ℝ V]
    (x₁ x₂ z : V) : Prop :=
  ∃ t : ℝ, 0 ≤ t ∧ t ≤ 1 ∧ z = t • x₁ + (1 - t) • x₂