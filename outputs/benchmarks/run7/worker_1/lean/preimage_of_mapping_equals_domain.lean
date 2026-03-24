import Mathlib

open Set

variable {S T : Type}

-- Axiomatize the definition of a mapping
axiom IsMapping (f : Set (S × T)) : Prop

-- Define the domain of a relation
def Dom (f : Set (S × T)) : Set S := {x | ∃ y, (x, y) ∈ f}

-- Define the preimage of a relation (for the entire codomain T)