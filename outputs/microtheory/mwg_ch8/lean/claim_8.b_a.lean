import Mathlib
open Topology

def StrictlyDominant {S O : Type*} (u : S → O → ℝ) (s : S) : Prop :=
  ∀ s', s' ≠ s → ∀ t, u s' t < u s t