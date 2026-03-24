import Mathlib

open Pointwise BigOperators
open Topology
open BigOperators

theorem sum_convex_sets {𝕜 E : Type*} [Semiring 𝕜] [PartialOrder 𝕜] [AddCommMonoid E]
    [Module 𝕜 E] {ι : Type*} [DecidableEq ι] {s : Finset ι} {S : ι → Set E}
    (hS : ∀ i ∈ s, Convex 𝕜 (S i)) :
    Convex 𝕜 (∑ i ∈ s, S i) := by
  induction s using Finset.induction_on with
  | empty =>
    simp
    exact convex_singleton 0
  | @insert a s' ha ih =>
    rw [Finset.sum_insert ha]
    exact (hS a (Finset.mem_insert_self a s')).add
      (ih (fun i hi => hS i (Finset.mem_insert_of_mem hi)))