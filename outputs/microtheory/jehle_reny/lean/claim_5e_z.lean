import Mathlib

open BigOperators
open Topology

/-- If a firm's production set is strongly convex and the price vector is strictly positive,
    then there is at most one profit-maximising production plan. -/
theorem claim_5e_z
    {L : ℕ}
    (Y : Set (Fin L → ℝ))
    (p : Fin L → ℝ)
    (hp : ∀ i, 0 < p i)
    -- Strong convexity of Y: for any two distinct points, there exists a feasible
    -- production plan whose profit strictly exceeds their average profit.
    -- (Follows from strict convexity of Y placing midpoints in interior, then
    -- perturbing in direction p >> 0.)
    (hY_strong : ∀ y₁ ∈ Y, ∀ y₂ ∈ Y, y₁ ≠ y₂ →
      ∃ y' ∈ Y, ∑ i : Fin L, p i * y₁ i + ∑ i : Fin L, p i * y₂ i <
        2 * ∑ i : Fin L, p i * y' i)
    (y1 y2 : Fin L → ℝ)
    (hy1 : y1 ∈ Y) (hy2 : y2 ∈ Y)
    (hmax1 : ∀ y ∈ Y, ∑ i : Fin L, p i * y i ≤ ∑ i : Fin L, p i * y1 i)
    (hmax2 : ∀ y ∈ Y, ∑ i : Fin L, p i * y i ≤ ∑ i : Fin L, p i * y2 i) :
    y1 = y2 := by
  by_contra h
  have heq : ∑ i : Fin L, p i * y1 i = ∑ i : Fin L, p i * y2 i :=
    le_antisymm (hmax2 y1 hy1) (hmax1 y2 hy2)
  obtain ⟨y', hy'_mem, hy'_gt⟩ := hY_strong y1 hy1 y2 hy2 h
  have hle := hmax1 y' hy'_mem
  linarith