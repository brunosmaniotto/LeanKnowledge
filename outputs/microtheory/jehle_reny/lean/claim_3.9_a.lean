import Mathlib
open Topology

/-- Homogeneity of the unrestricted profit function in all prices does not carry over
    to homogeneity of the restricted profit function in variable input prices alone. -/
theorem claim_3_9_a :
    ∃ (π : ℝ → ℝ → ℝ),
      (∀ t p w, 0 < t → 0 < w → π (t * p) (t * w) = t * π p w) ∧
      ¬(∀ t w, 0 < t → 0 < w → π 1 (t * w) = t * π 1 w) := by
  use fun p w => p ^ 2 / (4 * w)
  constructor
  · intro t p w ht hw
    have : (4 : ℝ) * w ≠ 0 := by positivity
    have : (4 : ℝ) * (t * w) ≠ 0 := by positivity
    field_simp
  · intro h
    have := h 2 1 (by norm_num) (by norm_num)
    norm_num at this