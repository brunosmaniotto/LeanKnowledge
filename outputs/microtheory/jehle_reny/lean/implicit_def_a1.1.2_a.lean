import Mathlib
open Topology

/-- A constructive (direct) proof of 'A ⇒ B': a function that assumes A
    and produces B. In Lean's type theory, this is exactly `A → B`. -/
def DirectProof (A B : Prop) : Prop := A → B