import Mathlib
open Topology

/-- Hidden information model where effort is observable but the state θ is private. -/
structure HiddenInfoModel where
  /-- Gross profit as a deterministic function of effort -/
  π : ℝ → ℝ
  /-- Disutility of effort in monetary units, depending on effort and state -/
  g : ℝ → ℝ → ℝ
  /-- Strictly increasing, strictly concave valuation function -/
  v : ℝ → ℝ
  /-- π(0) = 0 -/
  profit_zero : π 0 = 0
  /-- π is strictly increasing -/
  profit_increasing : ∀ e, 0 < deriv π e
  /-- π is strictly concave: π''(e) < 0 -/
  profit_concave : ∀ e, deriv (deriv π) e < 0
  /-- v is strictly concave (strict risk aversion): v''(·) < 0 -/
  v_concave : ∀ x, deriv (deriv v) x < 0

namespace HiddenInfoModel

/-- The manager's utility: u(w, e, θ) = v(w - g(e, θ)) -/
noncomputable def utility (M : HiddenInfoModel) (w e θ : ℝ) : ℝ :=
  M.v (w - M.g e θ)

end HiddenInfoModel