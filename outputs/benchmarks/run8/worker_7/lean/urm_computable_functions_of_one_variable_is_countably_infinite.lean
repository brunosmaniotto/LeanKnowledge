import Mathlib

open Set

/-- The set of all partial recursive functions of one variable. -/
def partialRecursiveSet : Set (ℕ →. ℕ) := {f | Nat.Partrec f}