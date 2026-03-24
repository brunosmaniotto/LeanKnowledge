import Mathlib
open Finset
open BigOperators
open Topology

variable {I : Type*} [Fintype I] [DecidableEq I] [Nonempty I]
variable {X : Type*}
variable (v : I → X → ℝ)

noncomputable def totalValue (x : X) : ℝ := ∑ i, v i x

def isParetoEfficient (x : X) : Prop :=
  ¬ ∃ (y : X) (s : I → ℝ), (∑ i, s i = 0) ∧ (∀ i, v i y + s i ≥ v i x) ∧ (∃ i, v i y + s i > v i x)