import Mathlib

open MeasureTheory

/-- First-order stochastic dominance via CDFs: F FOSD G iff F(t) ≤ G(t) for all t.
    When F arises from G by adding a nonneg random variable (upward shift),
    F(t) = P(X + Z ≤ t) ≤ P(X ≤ t) = G(t) since Z ≥ 0. -/
theorem claim_6D_c
    {X Z : ℝ → ℝ}
    (hZ_nonneg : ∀ ω, 0 ≤ Z ω)
    : ∀ t : ℝ, {ω | X ω + Z ω ≤ t} ⊆ {ω | X ω ≤ t} := by
  intro t ω hω
  simp only [Set.mem_setOf_eq] at hω ⊢
  linarith [hZ_nonneg ω]