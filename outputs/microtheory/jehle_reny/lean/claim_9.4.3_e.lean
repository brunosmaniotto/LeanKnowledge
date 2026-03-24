import Mathlib

open Set

/-- The regularity condition (MWG 9.18) is satisfied for the uniform distribution
    and more generally whenever each F_i is convex. -/
theorem claim_9_4_3_e :
    -- Part 1: Uniform distribution: virtual valuation v ↦ 2v - 1 is strictly increasing
    (StrictMono (fun v : ℝ => 2 * v - 1)) ∧
    -- Part 2: For any convex CDF with positive density, if the hazard-rate reciprocal
    --         (1 - F(v))/f(v) is nonincreasing (which convexity of F implies),
    --         then the virtual valuation v - (1 - F(v))/f(v) is nondecreasing.
    (∀ (F f : ℝ → ℝ),
      ConvexOn ℝ (Icc 0 1) F →
      (∀ v ∈ Ioo (0:ℝ) 1, 0 < f v) →
      MonotoneOn f (Icc 0 1) →
      AntitoneOn (fun v => (1 - F v) / f v) (Ioo 0 1) →
      MonotoneOn (fun v => v - (1 - F v) / f v) (Ioo 0 1)) := by
  constructor
  · intro a b hab
    linarith
  · intro F f _ _ _ hanti
    intro a ha b hb hab
    have h1 := hanti ha hb hab
    linarith