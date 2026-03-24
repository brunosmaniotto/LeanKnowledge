import Mathlib

/-- If a production set Y satisfies free disposal (closed downward),
    and all first-period outputs are nonneg, then truncation is possible:
    (yb, 0) ∈ Y whenever (yb, ya) ∈ Y with yb ≥ 0. -/
theorem truncation_from_free_disposal
    {Y : Set (ℝ × ℝ)}
    (free_disposal : ∀ y ∈ Y, ∀ z : ℝ × ℝ, z.1 ≤ y.1 → z.2 ≤ y.2 → z ∈ Y)
    {yb ya : ℝ}
    (hy : (yb, ya) ∈ Y)
    (hb : 0 ≤ yb)
    (ha : 0 ≤ ya) :
    (yb, 0) ∈ Y := by
  exact free_disposal (yb, ya) hy (yb, 0) le_rfl (by linarith)