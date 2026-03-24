import Mathlib

variable (K V : Type*) [Field K] [AddCommGroup V] [Module K V]

/-- A set `S` of vectors is linearly dependent if the inclusion map is not linearly independent. -/
def LinearlyDependent (S : Set V) : Prop :=
  ¬ LinearIndependent K (Subtype.val : S → V)