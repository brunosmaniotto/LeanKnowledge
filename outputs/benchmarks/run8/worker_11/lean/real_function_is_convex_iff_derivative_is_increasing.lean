import Mathlib

-- Axiomatized sub-lemmas (as given in the prompt)
-- These correspond to `ConvexOn.monotone_deriv_of_differentiableOn` and
-- `convexOn_of_deriv_monotone_on` in Mathlib.

axiom convex_implies_deriv_increasing {a b : ℝ} {f : ℝ → ℝ} (h_conv : ConvexOn ℝ (Set.Ioo a b) f) (h_diff : DifferentiableOn ℝ f (Set.Ioo a b)) : MonotoneOn (deriv f) (Set.Ioo a b)
axiom deriv_increasing_implies_convex {a b : ℝ} {f : ℝ → ℝ} (h_diff : DifferentiableOn ℝ f (Set.Ioo a b)) (h_mono : MonotoneOn (deriv f) (Set.Ioo a b)) : ConvexOn ℝ (Set.Ioo a b) f

-- Main theorem
-- In Mathlib, this theorem is called `convexOn_iff_deriv_monotone_on`.

theorem real_function_is_convex_iff_derivative_is_increasing {a b : ℝ} {f : ℝ → ℝ}
    (h_diff : DifferentiableOn ℝ f (Set.Ioo a b)) :
    ConvexOn ℝ (Set.Ioo a b) f ↔ MonotoneOn (deriv f) (Set.Ioo a b) := by
  -- An iff-proof has two directions. We use the `constructor` tactic to split the goal.
  constructor
  · -- First, prove the forward direction: `ConvexOn` implies `MonotoneOn (deriv f)`.
    -- We introduce the assumption that `f` is convex.
    intro h_conv
    -- The first axiom `convex_implies_deriv_increasing` proves this direction directly,
    -- given the convexity of `f` and the differentiability of `f`.
    exact convex_implies_deriv_increasing h_conv h_diff
  · -- Second, prove the backward direction: `MonotoneOn (deriv f)` implies `ConvexOn`.
    -- We introduce the assumption that the derivative is monotone.
    intro h_mono
    -- The second axiom `deriv_increasing_implies_convex` proves this direction directly,
    -- given the differentiability of `f` and the monotonicity of its derivative.
    exact deriv_increasing_implies_convex h_diff h_mono