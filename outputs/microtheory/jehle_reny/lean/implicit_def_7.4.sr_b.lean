import Mathlib

open Finset BigOperators
open BigOperators

/-- The expected payoff to player i conditional on information set `I` having been reached,
    given beliefs `p` over nodes in `I` and payoff function `u` (encoding `u_i(b | x)`
    for a fixed assessment `(p, b)`).
    v_i(p, b | I) = Σ_{x ∈ I} p(x) · u_i(b | x) -/
noncomputable def expectedPayoffAtInfoSet
    {Node : Type*} [DecidableEq Node]
    (I : Finset Node)
    (p : Node → ℝ)
    (u : Node → ℝ) : ℝ :=
  ∑ x ∈ I, p x * u x