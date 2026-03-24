import Mathlib

/-- A linear utility function over monetary gains, capturing risk neutrality.
    Under this assumption, maximizing expected utility reduces to maximizing
    expected monetary gains (no risk aversion or risk preference). -/
structure LinearUtility where
  /-- Slope: marginal utility of money -/
  a : ℝ
  /-- Intercept: base utility level -/
  b : ℝ
  /-- Marginal utility is strictly positive -/
  a_pos : 0 < a

namespace LinearUtility

/-- Evaluate the linear utility at a given monetary gain `x`: `u(x) = a * x + b`. -/
noncomputable def eval (u : LinearUtility) (x : ℝ) : ℝ :=
  u.a * x + u.b

end LinearUtility