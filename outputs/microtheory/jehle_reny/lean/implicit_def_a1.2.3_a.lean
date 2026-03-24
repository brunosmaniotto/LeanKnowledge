import Mathlib
open Topology

/-- A binary relation between sets S and T is any subset of S × T.
    When s bears the relation to t, we write (s, t) ∈ R. -/
abbrev BinaryRelation (S T : Type*) := Set (S × T)