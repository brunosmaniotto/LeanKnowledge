import Mathlib

open Finset BigOperators
open BigOperators

/-- An incentive-compatible direct mechanism with cost functions `c` and
    allocation rule `q` runs an expected surplus if ex ante expected revenue
    is non-negative in the truth-telling equilibrium. -/
def expected_surplus {T : Type*} [Fintype T] {N : ℕ}
    (q : T → ℝ) (c : Fin N → T → ℝ) : Prop :=
  ∑ t : T, q t * (∑ i : Fin N, c i t) ≥ 0