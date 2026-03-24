import Mathlib

open Matrix
open Equiv.Perm
open Finset
open scoped BigOperators

variable {n : ℕ} {R : Type _} [CommRing R]

def pairs : Finset (Fin n × Fin n) :=
  Finset.filter (fun (i, j) => i < j) Finset.univ