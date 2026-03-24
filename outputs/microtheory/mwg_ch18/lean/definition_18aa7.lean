import Mathlib

open Finset BigOperators
open BigOperators

/-- The marginal contribution of player `i` to coalition `S`. -/
noncomputable def marginal_contribution {I : Type*} [DecidableEq I]
    (v : Finset I → ℝ) (S : Finset I) (i : I) : ℝ :=
  v (S ∪ {i}) - v S

/-- The set of predecessors of player `i` in a given ordering represented as a list. -/
def predecessors_in_order {I : Type*} [DecidableEq I] (order : List I) (i : I) : Finset I :=
  (order.takeWhile (· ≠ i)).toFinset

/-- Convert a permutation to an ordered list of elements. -/
noncomputable def perm_to_list {I : Type*} [Fintype I] (π : Equiv.Perm I) : List I :=
  (Finset.univ.val.map π).toList

/-- The Shapley value of player `i` in a cooperative game with player set `I` and
    characteristic function `v`. It equals the average marginal contribution of `i`
    over all orderings of the player set. -/
noncomputable def shapley_value {I : Type*} [DecidableEq I] [Fintype I]
    (v : Finset I → ℝ) (i : I) : ℝ :=
  (1 / (Fintype.card I).factorial : ℝ) *
    ∑ π : Equiv.Perm I,
      marginal_contribution v (predecessors_in_order (perm_to_list π) i) i