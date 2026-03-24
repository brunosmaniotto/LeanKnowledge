import Mathlib

-- TU game: finite set of players, characteristic function on coalitions
structure TUGame (I : Type*) [Fintype I] [DecidableEq I] where
  v : Finset I → ℝ

noncomputable section

open Finset BigOperators
open BigOperators

variable {I : Type*} [Fintype I] [DecidableEq I]

-- An allocation is in the core if it is efficient and no coalition can improve
def inCore (G : TUGame I) (x : I → ℝ) : Prop :=
  (∑ i ∈ Finset.univ, x i) = G.v Finset.univ ∧
  ∀ S : Finset I, (∑ i ∈ S, x i) ≥ G.v S