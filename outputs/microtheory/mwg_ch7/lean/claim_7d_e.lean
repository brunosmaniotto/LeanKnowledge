import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- The total number of strategies for a player with N information sets,
    where information set n has M_n possible actions, is ∏_{n=1}^{N} M_n. -/
theorem strategy_count
    {N : ℕ}
    (ActionAt : Fin N → Type*)
    [∀ n, Fintype (ActionAt n)]
    [∀ n, DecidableEq (ActionAt n)] :
    Fintype.card (∀ n, ActionAt n) = ∏ n : Fin N, Fintype.card (ActionAt n) := by
  exact Fintype.card_pi