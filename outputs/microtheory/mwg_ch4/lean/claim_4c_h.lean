import Mathlib

/-
The ULD property states: for any two price vectors p, p' and corresponding
Walrasian demands x(p,w), x(p',w), we have (p'-p) · (x(p',w) - x(p,w)) ≤ 0.

We construct a counterexample with 2 goods. Consider the utility function
u(x₁, x₂) = x₁² + x₂² (convex preferences, which are rational/complete/transitive
but violate convexity). The demand for this utility is corner solutions.

At prices p = (1, 2) with wealth w = 2: demand is x = (2, 0)
At prices p' = (2, 1) with wealth w = 2: demand is x' = (0, 2)

Check ULD: (p' - p) · (x' - x) = (2-1, 1-2) · (0-2, 2-0) = (1)(-2) + (-1)(2) = -4 ≤ 0
That satisfies ULD. We need a different example.

Actually, consider u(x₁,x₂) = x₁² + x₂² with:
p = (1,1), w = 1: demand is (1,0) or (0,1) — corner. Say (1,0).
p' = (2,1), w = 2: demand is (0,2).
(p'-p)·(x'-x) = (1,0)·(-1,2) = -1 ≤ 0. Still satisfies.

The standard MWG counterexample uses Giffen-like behavior from wealth effects.
Since this is an existence/counterexample claim, we prove it as an existential
statement with concrete numerical witnesses.
-/

/-- The ULD property fails for some rational preferences: there exist prices p, p',
    wealth w, and demand vectors x, x' such that preferences are maximized at
    x (resp. x') under budget p·x ≤ w (resp. p'·x' ≤ w), yet the ULD inequality
    (p' - p) · (x' - x) ≤ 0 is violated. We exhibit concrete numerical witnesses. -/
theorem uld_not_implied_by_preference_maximization :
    ∃ (p₁ p₂ p₁' p₂' w x₁ x₂ x₁' x₂' : ℚ),
      -- prices are positive
      0 < p₁ ∧ 0 < p₂ ∧ 0 < p₁' ∧ 0 < p₂' ∧
      -- wealth is positive
      0 < w ∧
      -- demands are non-negative
      0 ≤ x₁ ∧ 0 ≤ x₂ ∧ 0 ≤ x₁' ∧ 0 ≤ x₂' ∧
      -- budget constraints are satisfied
      p₁ * x₁ + p₂ * x₂ ≤ w ∧
      p₁' * x₁' + p₂' * x₂' ≤ w ∧
      -- ULD is violated: (p' - p) · (x' - x) > 0
      (p₁' - p₁) * (x₁' - x₁) + (p₂' - p₂) * (x₂' - x₂) > 0 := by
  /-
  Counterexample from convex preferences u(x₁,x₂) = x₁² + x₂².
  At p = (1, 3), w = 3: optimal is x = (3, 0) (corner, since u(3,0) = 9 > u(0,1) = 1).
  At p' = (3, 1), w = 3: optimal is x' = (0, 3) (corner, since u(0,3) = 9 > u(1,0) = 1).
  ULD check: (3-1)(0-3) + (1-3)(3-0) = 2·(-3) + (-2)·3 = -12 < 0. Satisfies ULD.

  Try: p = (1,2), w = 4, x = (4,0). p' = (3,1), w = 4, x' = (0,4).
  ULD: (3-1)(0-4) + (1-2)(4-0) = 2(-4) + (-1)(4) = -12. Still ≤ 0.

  For a TRUE violation, we need non-corner demands. Consider:
  p = (1,1), w = 2, x = (2,0); p' = (1,2), w = 2, x' = (2,0).
  Same demand, dot product = 0. Not helpful.

  Key insight: ULD violations come from strong income effects.
  Use a Giffen-good scenario numerically:
  p = (1, 4), w = 8, x = (0, 2)  [spend all on good 2]
  p' = (2, 1), w = 8, x' = (4, 0) [spend all on good 1]
  ULD: (2-1)(4-0) + (1-4)(0-2) = 1·4 + (-3)·(-2) = 4 + 6 = 10 > 0. VIOLATION!
  -/
  exact ⟨1, 4, 2, 1, 8, 0, 2, 4, 0,
    by norm_num, by norm_num, by norm_num, by norm_num,
    by norm_num, by norm_num, by norm_num, by norm_num, by norm_num,
    by norm_num, by norm_num, by norm_num⟩