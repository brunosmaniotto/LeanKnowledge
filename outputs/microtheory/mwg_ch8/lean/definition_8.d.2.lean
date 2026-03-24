import Mathlib
open Topology

structure MixedGame where
  I : Type
  [instI : Fintype I]
  [instDecEqI : DecidableEq I]
  S : I → Type
  [instS : ∀ i, Fintype (S i)]
  [instDecEqS : ∀ i, DecidableEq (S i)]
  u : (i : I) → ((j : I) → PMF (S j)) → ℝ

attribute [instance] MixedGame.instI MixedGame.instS MixedGame.instDecEqI MixedGame.instDecEqS

def MixedGame.MixedNashEquilibrium (G : MixedGame) (σ : (i : G.I) → PMF (G.S i)) : Prop :=
  ∀ (i : G.I) (σ'_i : PMF (G.S i)),
    G.u i σ ≥ G.u i (Function.update σ i σ'_i)