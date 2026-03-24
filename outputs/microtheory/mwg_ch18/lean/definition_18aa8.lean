import Mathlib

/-- A coalitional game (I, v) is convex if marginal contributions are non-decreasing
    in coalition size: for S ⊆ T and i ∉ T, v(S ∪ {i}) - v(S) ≤ v(T ∪ {i}) - v(T). -/
def IsConvexGame {I : Type*} [DecidableEq I] (v : Finset I → ℝ) : Prop :=
  ∀ (S T : Finset I), S ⊆ T → ∀ i, i ∉ T →
    v (S ∪ {i}) - v S ≤ v (T ∪ {i}) - v T