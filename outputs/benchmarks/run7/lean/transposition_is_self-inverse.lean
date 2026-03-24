import Mathlib.GroupTheory.Perm.Cycle.Type

-- Proved sub-lemma 1: Applying a swap twice to one of the swapped elements returns the element.
lemma apply_swap_twice_to_swapped_element {α : Type*} [DecidableEq α] (a b : α) : (Equiv.swap a b * Equiv.swap a b) a = a := by
  simp

-- Proved sub-lemma 2: Applying a swap twice to an element not involved in the swap returns the element.