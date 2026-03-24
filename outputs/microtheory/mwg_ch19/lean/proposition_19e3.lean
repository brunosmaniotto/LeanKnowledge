import Mathlib

open Finset BigOperators
open Topology
open BigOperators

def colSpan {S K : Type*} [Fintype K] (R : S → K → ℝ) : Set (S → ℝ) :=
  Set.range (fun z : K → ℝ => fun s => ∑ k, R s k * z k)