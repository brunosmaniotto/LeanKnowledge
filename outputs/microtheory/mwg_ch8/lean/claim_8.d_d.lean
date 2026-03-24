import Mathlib
open Topology

variable {I : Type*} [Fintype I] [DecidableEq I]
variable {S : I → Type*} [∀ i, Fintype (S i)] [∀ i, DecidableEq (S i)]
variable (u : (∀ i, S i) → I → ℝ)

def IsBestResponse (u : (∀ i, S i) → I → ℝ) (i : I) (s : ∀ i, S i) : Prop :=
  ∀ s_i' : S i, u s i ≥ u (Function.update s i s_i') i