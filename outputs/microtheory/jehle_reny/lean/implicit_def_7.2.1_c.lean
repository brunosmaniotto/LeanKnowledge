import Mathlib
open Topology

variable {I : Type*} [DecidableEq I] [Fintype I]
variable {S : I → Type*} [∀ i, Fintype (S i)] [∀ i, DecidableEq (S i)]

def IsWeaklyDominatedIn (u : (∀ i, S i) → I → ℝ) (i : I) (W : ∀ j, Set (S j)) (si : S i) : Prop :=
  ∃ si' ∈ W i, si' ≠ si ∧
    (∀ s : ∀ j, S j, (∀ j, j ≠ i → s j ∈ W j) → u (Function.update s i si') i ≥ u (Function.update s i si) i) ∧
    (∃ s : ∀ j, S j, (∀ j, j ≠ i → s j ∈ W j) ∧ u (Function.update s i si') i > u (Function.update s i si) i)