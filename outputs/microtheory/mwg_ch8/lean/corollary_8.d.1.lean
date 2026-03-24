import Mathlib

open Finset BigOperators
open Topology
open BigOperators

structure MixedGame where
  I : Type*
  [instI : Fintype I]
  [instDecI : DecidableEq I]
  S : I → Type*
  [instS : ∀ i, Fintype (S i)]
  [instDecS : ∀ i, DecidableEq (S i)]
  [instNe : ∀ i, Nonempty (S i)]
  utility : (∀ i, S i) → I → ℝ

attribute [instance] MixedGame.instI MixedGame.instDecI MixedGame.instS
  MixedGame.instDecS MixedGame.instNe

namespace MixedGame

variable (G : MixedGame)

def MixedStrat (i : G.I) := { σ : G.S i → ℝ // (∀ s, 0 ≤ σ s) ∧ ∑ s : G.S i, σ s = 1 }