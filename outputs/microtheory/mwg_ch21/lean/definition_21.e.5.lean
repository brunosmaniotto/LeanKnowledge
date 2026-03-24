import Mathlib
open Topology

def IsDictator {I X : Type*} (A : Set (I → X → X → Prop)) (f : (I → X → X → Prop) → X) (h : I) : Prop :=
  ∀ profile ∈ A, ∀ y : X, profile h (f profile) y