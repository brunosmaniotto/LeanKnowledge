import Mathlib

open Set Function Finset Classical

-- We define a NormalFormGame structure.
structure NormalFormGame where
  I : Type
  [instFintypeI : Fintype I]
  [instDecidableEqI : DecidableEq I]
  S : I → Type
  [instFintypeS : ∀ i, Fintype (S i)]
  [instDecidableEqS : ∀ i, DecidableEq (S i)]
  u : (∀ i, S i) → I → ℝ

namespace NormalFormGame

variable (Γ : NormalFormGame) -- Now Γ carries its own instances

-- A helper function to create a strategy profile from a choice function
def make_strategy_profile (available_strategies : ∀ k, Set (Γ.S k)) (choice_fun : ∀ k, Γ.S k) : (∀ k, Γ.S k) :=
  fun k => choice_fun k

-- A strategy `si` is strictly dominated by `si'` given a set of available strategies for other players.