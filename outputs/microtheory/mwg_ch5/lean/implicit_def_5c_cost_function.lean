import Mathlib

open scoped BigOperators
open Topology
open BigOperators

noncomputable section

variable {n : ℕ}

/-- A production function maps input vectors to output levels. -/
structure ProdFn (n : ℕ) where
  toFun : (Fin n → ℝ) → ℝ

/-- The cost function c(w, q): the infimum of w · z over all feasible input
    vectors z ≥ 0 producing at least output q. This is the optimized value
    of the cost minimization problem (CMP). -/
noncomputable def costFunction (f : ProdFn n) (w : Fin n → ℝ) (q : ℝ) : ℝ :=
  iInf fun z : { z : Fin n → ℝ // (∀ i, 0 ≤ z i) ∧ q ≤ f.toFun z } =>
    ∑ i, w i * z.val i

/-- The conditional factor demand correspondence z(w, q): the set of cost-minimizing
    input vectors. These are the inputs z ≥ 0 with f(z) ≥ q that achieve the
    minimum cost w · z = c(w, q). Called 'conditional' because demands are
    conditional on producing output level q. -/
def conditionalFactorDemand (f : ProdFn n) (w : Fin n → ℝ) (q : ℝ) :
    Set (Fin n → ℝ) :=
  {z | (∀ i, 0 ≤ z i) ∧ q ≤ f.toFun z ∧
       ∑ i, w i * z i = costFunction f w q}

end