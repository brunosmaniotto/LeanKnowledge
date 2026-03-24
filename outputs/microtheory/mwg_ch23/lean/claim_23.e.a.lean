import Mathlib

open Finset BigOperators
open Topology

def ExPostPC (f : Fin n → Fin n → ℝ) : Prop :=
  ∀ i j, 0 ≤ f i j