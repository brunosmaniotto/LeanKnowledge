import Mathlib

open Finset BigOperators

structure CharFormGame (I : Type*) [Fintype I] [DecidableEq I] where
  V : Finset I → Set (I → ℝ)

def CharFormGame.isBlocked {I : Type*} [Fintype I] [DecidableEq I]
    (G : CharFormGame I) (u : I → ℝ) (S : Finset I) : Prop :=
  ∃ u' ∈ G.V S, ∀ i ∈ S, u i < u' i

structure TUGame (I : Type*) [Fintype I] [DecidableEq I] where
  v : Finset I → ℝ