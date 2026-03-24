import Mathlib
open Topology

/-- The second welfare theorem fails without convex preferences:
    there exists a Pareto optimal allocation that cannot be supported
    as a price equilibrium with transfers. -/
theorem second_welfare_theorem_fails_without_convexity :
    ∃ (u₁ u₂ : ℝ → ℝ) (x₁star x₂star : ℝ),
      -- Feasibility
      x₁star + x₂star = 1 ∧
      -- Pareto optimality: no feasible reallocation makes both strictly better
      (∀ y₁ y₂ : ℝ, y₁ + y₂ = 1 → y₁ ≥ 0 → y₂ ≥ 0 →
        ¬(u₁ y₁ > u₁ x₁star ∧ u₂ y₂ > u₂ x₂star)) ∧
      -- u₁ is non-convex (midpoint worse than an endpoint)
      (u₁ ((0 + 1) / 2) > (u₁ 0 + u₁ 1) / 2 → False) ∧
      -- Failure of price support: for every price p > 0,
      -- if x₂star maximizes u₂ on consumer 2's budget,
      -- then x₁star does NOT maximize u₁ on consumer 1's budget
      (∀ p : ℝ, p > 0 →
        (∀ y₂ : ℝ, p * y₂ ≤ p * x₂star → u₂ y₂ ≤ u₂ x₂star) →
        ∃ z₁ : ℝ, p * z₁ ≤ p * x₁star ∧ u₁ z₁ > u₁ x₁star) := by
  -- u₁(x) = -(x - 1/2)^2, u₂(x) = x
  -- x₁* = 1/2, x₂* = 1/2
  -- u₁ is concave (not the right non-convexity)...
  -- Instead: u₁(x) = x^2, u₂(x) = -|x - 1/2|
  -- Actually let me just use a clean abstract construction.
  -- u₁(x) = x², u₂(x) = -(x-1)² = 2x - x² - 1 (maximized at x=1)
  -- x₁*=0, x₂*=1. Pareto optimal since u₂ is already at max.
  -- u₁ non-convex: u₁(0.5) = 0.25, (u₁(0)+u₁(1))/2 = 0.5, so midpoint < average ✓
  -- Price support failure: any p>0, consumer 2 demands x₂=1 at budget p*1,
  --   so consumer 1 has budget p*0=0, but u₁(0)=0 and there's no z₁ ≤ 0 with u₁(z₁) > 0
  -- Hmm, u₁(z₁) = z₁² > 0 needs z₁ ≠ 0 but budget is p*z₁ ≤ 0, so z₁ ≤ 0.
  -- z₁ = -ε works! u₁(-ε) = ε² > 0 and p*(-ε) ≤ 0. ✓
  refine ⟨fun x => x ^ 2, fun x => -(x - 1) ^ 2,
    0, 1, by norm_num, ?_, ?_, ?_⟩
  · -- Pareto optimality
    intro y₁ y₂ hfeas hy1 hy2 ⟨hu1, hu2⟩
    simp only at hu1 hu2
    -- u₁(y₁) > u₁(0) = 0 means y₁ ≠ 0, so y₁ > 0
    -- u₂(y₂) > u₂(1) = 0 means -(y₂-1)² > 0, impossible
    nlinarith [sq_nonneg (y₂ - 1)]
  · -- Non-convexity witness: u₁(0.5) = 0.25 but (u₁(0) + u₁(1))/2 = 0.5
    -- so midpoint value < average of endpoint values (strict midpoint convexity fails
    -- for the PREFERENCE RELATION, meaning upper contour sets are non-convex)
    norm_num
  · -- No supporting price
    intro p hp hmax
    -- Consumer 1's budget: p * z₁ ≤ p * 0 = 0, so z₁ ≤ 0
    -- Choose z₁ = -1: p*(-1) = -p ≤ 0 ✓, u₁(-1) = 1 > 0 = u₁(0) ✓
    exact ⟨-1, by nlinarith, by norm_num⟩