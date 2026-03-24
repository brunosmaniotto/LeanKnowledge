import Mathlib

variable (M : Type) [Monoid M]

def cancellative : Set M :=
  {x | ∀ a b, x * a = x * b → a = b} ∩ {x | ∀ a b, a * x = b * x → a = b}