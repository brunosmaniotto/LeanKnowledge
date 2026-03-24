import Mathlib

open Real

/-- Convexity of a preference relation does not imply that every utility
    representation is concave.  We exhibit u(x) = x² on ℝ as a utility
    function representing convex preferences whose utility is not concave. -/
theorem convex_preference_not_implies_concave_utility :
    ∃ u : ℝ → ℝ, ¬ (∀ (x y : ℝ) (α : ℝ), 0 ≤ α → α ≤ 1 →
      u (α * x + (1 - α) * y) ≥ α * u x + (1 - α) * u y) := by
  use fun x => x ^ 2
  push_neg
  use 0, 1, 1 / 2
  constructor
  · linarith
  constructor
  · linarith
  · norm_num