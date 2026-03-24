import Mathlib

theorem trichotomy_law (α : Type) [LinearOrder α] (a b : α) : a < b ∨ a = b ∨ b < a :=
  lt_trichotomy a b