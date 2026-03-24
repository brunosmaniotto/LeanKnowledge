import Mathlib

variable {S G : Type} [AddGroup G]

/-- The pointwise inverse of a function, defined as `f_star f x = -f x`. -/
def f_star (f : S → G) : S → G := λ x => -f x