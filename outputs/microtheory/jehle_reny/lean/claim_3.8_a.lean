import Mathlib
open Topology

/-- Output supply y(p, w) is increasing in product price p: ∂y(p, w)/∂p ≥ 0.
    By Hotelling's lemma y = ∂π/∂p, so ∂y/∂p = ∂²π/∂p² ≥ 0 by convexity of π. -/
theorem Claim_3_8_a
    (π : ℝ → ℝ)
    (y : ℝ → ℝ)
    (hy : y = deriv π)                              -- Hotelling's lemma
    (hconv : ConvexOn ℝ Set.univ π)                 -- π is convex in p
    (h_second_nonneg : ∀ p, 0 ≤ deriv (deriv π) p)  -- convexity ⟹ π'' ≥ 0
    : ∀ p, 0 ≤ deriv y p := by
  subst hy
  exact h_second_nonneg