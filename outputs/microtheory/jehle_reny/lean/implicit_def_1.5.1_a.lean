import Mathlib

/-- The relative price of good `i` in terms of good `j`.
    Given price vector `p`, this is `p i / p j`, measuring the number of
    units of good `j` that must be forgone to acquire one unit of good `i`. -/
noncomputable def relativePrice {L : Type*} (p : L → ℝ) (i j : L) : ℝ :=
  p i / p j