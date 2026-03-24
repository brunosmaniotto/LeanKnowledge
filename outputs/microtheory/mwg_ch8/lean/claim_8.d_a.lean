import Mathlib

open Finset BigOperators
open Topology
open BigOperators

variable {I : Type*} [DecidableEq I] [Fintype I]
variable {S : I → Type*} [∀ i, DecidableEq (S i)] [∀ i, Fintype (S i)]

structure MixedGame (I : Type*) (S : I → Type*) where
  utility : I → (∀ i, S i) → ℝ

noncomputable def expectedUtility
    (G : MixedGame I S)
    (σ : ∀ i, S i → ℝ)
    (i : I) : ℝ :=
  ∑ s : (∀ i, S i), (∏ j : I, σ j (s j)) * G.utility i s

def IsBestResponse
    (G : MixedGame I S)
    (σ : ∀ i, S i → ℝ)
    (i : I) : Prop :=
  ∀ σ_i' : S i → ℝ,
    expectedUtility G (Function.update σ i σ_i') i ≤ expectedUtility G σ i