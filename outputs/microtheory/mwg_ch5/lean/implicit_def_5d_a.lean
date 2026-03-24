import Mathlib

open scoped BigOperators
open BigOperators
open Topology

noncomputable section

variable {n : ℕ}

/-- A production function maps input vectors to output levels. -/
structure ProdFn (n : ℕ) where
  toFun : (Fin n → ℝ) → ℝ

/-- The cost function c(w, q) from Definition 5.C. -/
noncomputable def costFunction (f : ProdFn n) (w : Fin n → ℝ) (q : ℝ) : ℝ :=
  iInf fun z : { z : Fin n → ℝ // (∀ i, 0 ≤ z i) ∧ q ≤ f.toFun z } =>
    ∑ i, w i * z.val i

/-- C(q) = c(w, q): the cost function for a single-output firm,
    holding factor prices constant at w >> 0. (Definition 5.D(a)) -/
noncomputable def cost (f : ProdFn n) (w : Fin n → ℝ) (q : ℝ) : ℝ :=
  costFunction f w q

/-- AC(q) = C(q)/q: average cost for q > 0. (Definition 5.D(a)) -/
noncomputable def averageCost (f : ProdFn n) (w : Fin n → ℝ) (q : ℝ) : ℝ :=
  cost f w q / q

/-- C'(q) = dC(q)/dq: marginal cost, the derivative of the cost function
    with respect to output. (Definition 5.D(a)) -/
noncomputable def marginalCost (f : ProdFn n) (w : Fin n → ℝ) (q : ℝ) : ℝ :=
  deriv (cost f w) q

end