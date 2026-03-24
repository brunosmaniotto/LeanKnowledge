import Mathlib

open scoped Real
open Topology

/--
Given cost function c(q) = aq + bq² with a > 0, b < 0, market demand p = α − βq,
and J firms in the industry:
- Each firm's marginal cost is MC(q) = a + 2bq
- Setting p = MC gives firm supply q_j = (p - a) / (2b)
- Market clearing: p = α - β·J·q_j
- Solving yields equilibrium price p* = (2bα + aβJ) / (2b + βJ)
- and firm output q* = (α - a) / (2b + βJ)
-/
theorem Exercise_4_7_a
    (a b α β : ℝ) (J : ℝ)
    (ha : a > 0) (hb : b < 0) (hα : α > 0) (hβ : β > 0) (hJ : J > 0)
    (h_denom : 2 * b + β * J ≠ 0) :
    -- The equilibrium price satisfies p* = (2bα + aβJ) / (2b + βJ)
    -- and the firm output satisfies q* = (α - a) / (2b + βJ)
    -- where market clearing holds: p* = α - β * J * q*
    -- and the price equals marginal cost: p* = a + 2 * b * q*
    let q_star := (α - a) / (2 * b + β * J)
    let p_star := (2 * b * α + a * β * J) / (2 * b + β * J)
    p_star = α - β * J * q_star ∧ p_star = a + 2 * b * q_star := by
  constructor <;> field_simp <;> ring