import Mathlib

/-- Competitive limit setup for two-stage entry with Cournot competition. -/
structure CompetitiveLimitSetup where
  /-- Base demand function (differentiable, strictly decreasing) -/
  x : ℝ → ℝ
  /-- Cost function (strictly convex) -/
  c : ℝ → ℝ
  /-- Entry cost -/
  K : ℝ
  /-- Market size parameter -/
  α : ℝ
  /-- Efficient scale -/
  q_bar : ℝ
  /-- Minimum average cost -/
  c_bar : ℝ
  /-- α is positive -/
  α_pos : 0 < α
  /-- Entry cost is positive -/
  K_pos : 0 < K
  /-- Efficient scale is positive -/
  q_bar_pos : 0 < q_bar
  /-- x is differentiable -/
  x_diff : Differentiable ℝ x
  /-- x has strictly negative derivative -/
  x_deriv_neg : ∀ p, deriv x p < 0
  /-- c is strictly convex on nonneg reals -/
  c_strict_convex : StrictConvexOn ℝ (Set.Ici 0) c
  /-- q̄ achieves minimum average cost -/
  q_bar_minimizes : c_bar = (K + c q_bar) / q_bar
  /-- q̄ is a minimizer of average cost over positive quantities -/
  q_bar_is_min : ∀ q > 0, c_bar ≤ (K + c q) / q

/-- Scaled demand: x_α(p) = α * x(p) -/
noncomputable def CompetitiveLimitSetup.demand (S : CompetitiveLimitSetup) (p : ℝ) : ℝ :=
  S.α * S.x p

/-- Inverse demand: p_α(q) = p(q/α), where p is the inverse of x -/
noncomputable def CompetitiveLimitSetup.inverseDemand (S : CompetitiveLimitSetup) (p_inv : ℝ → ℝ) (q : ℝ) : ℝ :=
  p_inv (q / S.α)