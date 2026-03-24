import Mathlib

variable {M : Type} [Monoid M]

theorem identity_cancellable_left (x y : M) (h : 1 * x = 1 * y) : x = y := by
  simpa using h