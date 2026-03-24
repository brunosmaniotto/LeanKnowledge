import Mathlib

variable (S : Type) (star : S → S → S) (e : S)
  (h1 : ∀ a b, star a b = e ↔ a = b)
  (h2 : ∀ a b c, star (star a c) (star b c) = star a b)

namespace GroupConstruction

-- Define the new operation
def circ (a b : S) : S := star a (star e b)

-- Basic consequences of h1