import Mathlib

-- Social choice framework
variable {N : Type*} [Fintype N] [DecidableEq N]
variable {X : Type*} [Fintype X] [DecidableEq X]
variable [Inhabited X] -- Required for creating arbitrary LinearOrder instances.

-- Preference profile and social choice function
def PrefProfile (N X : Type*) := N → LinearOrder X