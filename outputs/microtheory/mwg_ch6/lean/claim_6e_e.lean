import Mathlib

open Finset BigOperators
open Topology
open BigOperators

structure EURep (S : Type*) [Fintype S] where
  u : S → ℝ → ℝ

def eurPref {S : Type*} [Fintype S] (eu : EURep S) (x y : S → ℝ) : Prop :=
  ∑ s : S, eu.u s (x s) ≥ ∑ s : S, eu.u s (y s)