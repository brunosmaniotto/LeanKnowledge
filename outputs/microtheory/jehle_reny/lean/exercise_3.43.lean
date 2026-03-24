import Mathlib
open Topology

/-- Long-run average cost c/y is the lower envelope of short-run average cost sc(x̄)/y:
    it is weakly below every short-run average cost curve, and touches each at the
    cost-minimizing fixed input x̄*. -/
theorem Exercise_3_43
    {X : Type*}
    (sc : X → ℝ)        -- short-run cost parameterized by fixed input x̄
    (c : ℝ)              -- long-run cost = min_x̄ sc(x̄)
    (y : ℝ)              -- output level
    (hy : 0 < y)
    (h_le : ∀ x, c ≤ sc x)            -- long-run cost ≤ every short-run cost
    (h_min : ∃ x₀, sc x₀ = c)         -- the minimum is attained
    : (∀ x, c / y ≤ sc x / y) ∧ (∃ x₀, sc x₀ / y = c / y) := by
  constructor
  · intro x
    apply div_le_div_of_nonneg_right (h_le x) (le_of_lt hy)
  · obtain ⟨x₀, hx₀⟩ := h_min
    exact ⟨x₀, by rw [hx₀]⟩