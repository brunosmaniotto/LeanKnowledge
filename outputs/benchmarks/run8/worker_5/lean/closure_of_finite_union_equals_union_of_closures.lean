import Mathlib

open Set
open Finset

variable {α : Type u} [TopologicalSpace α]

theorem closure_finset_union {ι : Type v} [DecidableEq ι] (s : Finset ι) (f : ι → Set α) :
    closure (⋃ i ∈ s, f i) = ⋃ i ∈ s, closure (f i) := by
  induction s using Finset.induction_on with
  | empty => simp
  | @insert a s ha ih =>
    rw [Finset.set_biUnion_insert, closure_union, ih, Finset.set_biUnion_insert]