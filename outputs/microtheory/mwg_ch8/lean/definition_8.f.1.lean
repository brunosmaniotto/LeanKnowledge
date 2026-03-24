import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- A finite normal-form game. -/
structure NormalFormGame where
  I : Type*
  [instI : Fintype I]
  [instDecI : DecidableEq I]
  S : I → Type*
  [instS : ∀ i, Fintype (S i)]
  [instDecS : ∀ i, DecidableEq (S i)]
  [instNS : ∀ i, Nonempty (S i)]
  utility : (i : I) → ((j : I) → S j) → ℝ

attribute [instance] NormalFormGame.instI NormalFormGame.instDecI
  NormalFormGame.instS NormalFormGame.instDecS NormalFormGame.instNS

abbrev NormalFormGame.MixedStrategy (G : NormalFormGame) :=
  (i : G.I) → G.S i → ℝ

def NormalFormGame.IsValidMixed (G : NormalFormGame) (σ : G.MixedStrategy) : Prop :=
  ∀ i, (∀ s, 0 ≤ σ i s) ∧ ∑ s : G.S i, σ i s = 1

noncomputable def NormalFormGame.expectedUtility (G : NormalFormGame)
    (i : G.I) (σ : G.MixedStrategy) : ℝ :=
  ∑ sp : (j : G.I) → G.S j, (∏ j : G.I, σ j (sp j)) * G.utility i sp