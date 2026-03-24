import Mathlib
open Matrix
open BigOperators
open Finset

variable (V : Type*) [Fintype V] [DecidableEq V]
variable (B : Finset (Finset V)) (k r l : ℕ)

structure BIBD : Prop where
  block_size : ∀ β ∈ B, β.card = k
  replication : ∀ i : V, (B.filter (fun β => i ∈ β)).card = r
  pairwise : ∀ (i j : V), i ≠ j → (B.filter (fun β => i ∈ β ∧ j ∈ β)).card = l

def incidenceMatrix : Matrix V (Finset V) ℤ :=
  fun i β => if β ∈ B ∧ i ∈ β then (1 : ℤ) else 0