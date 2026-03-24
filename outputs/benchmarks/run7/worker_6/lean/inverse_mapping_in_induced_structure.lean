import Mathlib

variable {S T : Type} [Mul S] [AddCommGroup T] (f : S → T)

/-- The induced structure inverse of a homomorphism into an abelian group. -/
def inducedStructureInverse : S → T := λ x => - f x