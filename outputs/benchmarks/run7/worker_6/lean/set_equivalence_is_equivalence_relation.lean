import Mathlib

variable {α β γ : Type*}

/-- Two sets are equivalent if there exists a bijection between them. -/
def SetEquiv (s : Set α) (t : Set β) : Prop :=
  Nonempty (s ≃ t)