import Mathlib

open Finset BigOperators
open BigOperators

/-- A cooperative solution f is Paretian if the sum of payoffs equals the grand
    coalition value for every characteristic form game. -/
def IsParetian {I : Type*} [Fintype I] [DecidableEq I]
    (f : ((Finset I) → ℝ) → (I → ℝ)) : Prop :=
  ∀ v : (Finset I) → ℝ, ∑ i : I, f v i = v Finset.univ