import Mathlib

variable {V : Type*} [AddCommGroup V] [Module ℝ V]

def IsAdditive (Y : Set V) : Prop :=
  (0 : V) ∈ Y ∧ ∀ y ∈ Y, ∀ y' ∈ Y, y + y' ∈ Y