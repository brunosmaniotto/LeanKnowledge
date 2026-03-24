import Mathlib

variable (R : Type _) [Ring R] (G : Type _) [AddCommGroup G] [Module R G] (S : Subring R)

/-- The S-module structure on G obtained by restricting the scalar multiplication from R to S. -/
instance : Module S G :=
  Module.compHom G (Subring.subtype S)