import Mathlib

open Finset BigOperators
open BigOperators

/-- Setup for mechanism design in the general (non-auction) setting.
    X is the finite set of social states, T i is the type space of individual i,
    q is a common prior over type profiles with full support and independent types. -/
structure MechanismDesignSetup where
  N : ℕ
  X : Type*
  X_fin : Fintype X
  T : Fin N → Type*
  T_fin : ∀ i, Fintype (T i)
  q : (∀ i : Fin N, T i) → ℝ
  q_pos : ∀ t, q t > 0
  q_marginal : (i : Fin N) → T i → ℝ
  q_indep : ∀ t, q t = ∏ i : Fin N, q_marginal i (t i)