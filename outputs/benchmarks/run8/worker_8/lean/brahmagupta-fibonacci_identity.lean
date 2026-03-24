import Mathlib.Tactic

variable {R : Type _} [CommRing R] (a b c d : R)

theorem brahmagupta_fibonacci_identity :
    (a ^ 2 + b ^ 2) * (c ^ 2 + d ^ 2) = (a * c + b * d) ^ 2 + (a * d - b * c) ^ 2 := by
  ring