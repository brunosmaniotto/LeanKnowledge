import Mathlib
open Topology

variable {I X : Type*}

def IsDecisive (h : I) (socialPref : (I → X → X → Prop) → X → X → Prop) : Prop :=
  ∀ (P : I → X → X → Prop) (x y : X), P h x y → socialPref P x y