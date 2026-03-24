import Mathlib
open Set
open Topology

-- Let v₁ be the bidder's true valuation.
-- Let y₂ be the probability of bidder 1 winning, as a function of their bid x.
-- We make these explicit arguments to the function and theorem to avoid ambiguity.

/-- The expected gain for bidder 1, E(g1) = y₂(x) * (v₁ - x). -/
noncomputable def expected_gain (v₁ : ℝ) (y₂ : ℝ → ℝ) (x : ℝ) : ℝ :=
  y₂ x * (v₁ - x)

/--
A necessary condition for an equilibrium point is that the expected gain is maximized.
This theorem formalizes this by stating that if a point `x₀` is an equilibrium
(i.e., its expected gain is greater than or equal to the gain at any other point `x`),
then it represents a maximum of the expected gain function on the set of all possible bids.
-/
theorem Claim_Vickrey3_p31_h (v₁ : ℝ) (y₂ : ℝ → ℝ) (x₀ : ℝ)
  (h_equilibrium : ∀ x, expected_gain v₁ y₂ x ≤ expected_gain v₁ y₂ x₀) :
  IsMaxOn (expected_gain v₁ y₂) univ x₀ := by
  -- The lemma `isMaxOn_univ_iff` states that a point `a` is a maximum for a function `f`
  -- on the entire set of real numbers (`univ`) if and only if `f(y) ≤ f(a)` for all `y`.
  -- `rwa` applies this rewrite and then closes the goal because the rewritten goal
  -- is identical to our hypothesis `h_equilibrium`.
  rwa [isMaxOn_univ_iff]