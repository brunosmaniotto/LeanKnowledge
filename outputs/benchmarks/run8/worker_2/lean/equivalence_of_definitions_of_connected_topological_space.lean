import Mathlib
open Set Topology

variable {X : Type*} [TopologicalSpace X]

def IsSeparated (A B : Set X) : Prop :=
  closure A ∩ B = ∅ ∧ A ∩ closure B = ∅