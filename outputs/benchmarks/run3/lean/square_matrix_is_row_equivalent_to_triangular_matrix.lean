import Mathlib

open Matrix
open Topology

variable {F : Type _} [Field F]

def UpperTriangular {n} (A : Matrix (Fin n) (Fin n) F) : Prop :=
  ∀ i j, j < i → A i j = 0