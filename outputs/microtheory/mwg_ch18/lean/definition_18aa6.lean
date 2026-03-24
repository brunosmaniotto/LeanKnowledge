import Mathlib

open Finset BigOperators
open BigOperators

/-- The core of a TU characteristic form game (I, v) is the set of utility vectors
    u : I → ℝ such that no coalition can block: every coalition S gets at least v(S),
    and the grand coalition pays at most v(I). -/
def TU_Core {I : Type*} [Fintype I] [DecidableEq I]
    (v : Finset I → ℝ) : Set (I → ℝ) :=
  { u | (∑ i ∈ Finset.univ, u i) ≤ v Finset.univ ∧
        ∀ S : Finset I, (∑ i ∈ S, u i) ≥ v S }