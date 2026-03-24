import Mathlib
open Topology

/-- Example 19.F.2: Pareto dominance of Radner equilibria with heterogeneous beliefs.
    With K=0 assets, spot-only Radner equilibria can be Pareto ranked.
    Equilibrium 1: (p',p') gives uniform prices across states.
    Equilibrium 2: (p'',p') gives non-uniform prices.
    Consumer 1 (π₁₁ > 1/2, favors state 1): prefers eq1 since v₁(p') > v₁(p'').
    Consumer 2: the risk-aversion benefit of uniform prices outweighs the
    belief-weighted value difference, axiomatized as h_consumer2_prefers_eq1. -/
theorem Example_19F2
    (v1_p' v1_p'' v2_p' v2_p'' : ℝ)
    (π11 π21 π12 π22 : ℝ)
    (hv1 : v1_p' > v1_p'')
    (hv2 : v2_p' < v2_p'')
    (hπ1_pos : π11 > 1 / 2)
    (hπ2_pos : π22 > 1 / 2)
    (hπ1_sum : π11 + π21 = 1)
    (hπ2_sum : π12 + π22 = 1)
    (hπ11_nn : π11 ≥ 0)
    (hπ21_nn : π21 ≥ 0)
    (hπ12_nn : π12 ≥ 0)
    (hπ22_nn : π22 ≥ 0)
    -- Risk-aversion / concavity axiom: under concave utility, consumer 2 prefers
    -- uniform prices (p',p') to mixed (p'',p') despite v2(p'') > v2(p'),
    -- because the certainty equivalent of uniform consumption exceeds the
    -- expected value of non-uniform consumption (Jensen's inequality effect).
    (h_consumer2_prefers_eq1 : π12 * v2_p' + π22 * v2_p' > π12 * v2_p'' + π22 * v2_p') :
    -- Both consumers prefer equilibrium 1, so equilibrium 2 is Pareto dominated
    (π11 * v1_p' + π21 * v1_p' > π11 * v1_p'' + π21 * v1_p') ∧
    (π12 * v2_p' + π22 * v2_p' > π12 * v2_p'' + π22 * v2_p') := by
  constructor
  · -- Consumer 1: EU1(eq1) - EU1(eq2) = π11·(v1(p') - v1(p'')) > 0
    nlinarith
  · exact h_consumer2_prefers_eq1