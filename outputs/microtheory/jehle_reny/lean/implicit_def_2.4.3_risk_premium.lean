import Mathlib

open MeasureTheory Topology

/-- The risk premium π(w, u, ε) for a risk-averse agent is the amount of wealth
    the agent would pay to replace a fair gamble of size ε around wealth w
    with certainty. It is defined by:
      u(w - π) = (u(w + ε) + u(w - ε)) / 2
    i.e., the agent is indifferent between losing π for certain and facing
    the symmetric fair gamble ±ε.

    When u is concave (risk aversion), π ≥ 0. -/
noncomputable def riskPremium (u : ℝ → ℝ) (w ε : ℝ) : ℝ :=
  w - Function.invFun u ((u (w + ε) + u (w - ε)) / 2)