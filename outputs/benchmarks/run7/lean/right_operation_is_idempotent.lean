import Mathlib

-- The right operation: given two elements, return the second.
def right_op {α : Type} : α → α → α := fun _ y => y

-- Theorem: For every element x, applying the right operation to x and x yields x.