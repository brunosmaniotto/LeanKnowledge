import Mathlib

/-- The efficient scale is the set of production levels that minimize average cost.
    Given a cost function `C : ℝ → ℝ`, the average cost at output `q > 0` is `C q / q`.
    The efficient scale consists of all positive output levels achieving the minimum average cost.
    When this set is a singleton `{q̄}`, `q̄` is called *the* efficient scale. -/
noncomputable def efficientScale (C : ℝ → ℝ) : Set ℝ :=
  { q : ℝ | 0 < q ∧ ∀ q' : ℝ, 0 < q' → C q / q ≤ C q' / q' }