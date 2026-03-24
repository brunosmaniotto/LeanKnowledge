import Mathlib

variable {α : Type} [LinearOrder α]

theorem max_idempotent (x : α) : max x x = x :=
  max_self x