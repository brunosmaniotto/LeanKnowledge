import Mathlib

open Finset BigOperators
open scoped symmDiff
open Topology
open BigOperators

/-- The mixed extension of a finite strategy set `S` is the probability simplex Δ(S):
    the set of all probability distributions over `S`, i.e., functions σ : S → ℝ
    such that σ(s) ≥ 0 for all s and ∑ s, σ(s) = 1. -/
def MixedExtension (S : Type*) [Fintype S] : Set (S → ℝ) :=
  {σ | (∀ s, 0 ≤ σ s) ∧ ∑ s : S, σ s = 1}