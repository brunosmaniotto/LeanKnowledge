import Mathlib

structure MixedGame where
  I : Type
  [instI : Fintype I]
  [instDecEqI : DecidableEq I]
  S : I → Type
  [instS : ∀ i, Fintype (S i)]
  [instDecEqS : ∀ i, DecidableEq (S i)]
  u : (i : I) → ((j : I) → PMF (S j)) → ℝ

attribute [instance] MixedGame.instI MixedGame.instS MixedGame.instDecEqI MixedGame.instDecEqS

def MixedGame.IsBestResponse (G : MixedGame) (i : G.I)
    (σ_neg_i : (j : G.I) → PMF (G.S j)) (σ_i : PMF (G.S i)) : Prop :=
  ∀ σ'_i : PMF (G.S i),
    G.u i (Function.update σ_neg_i i σ_i) ≥ G.u i (Function.update σ_neg_i i σ'_i)