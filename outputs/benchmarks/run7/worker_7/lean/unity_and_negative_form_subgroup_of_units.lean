import Mathlib

open Set

variable (R : Type _) [Ring R]

/-- The subgroup of units consisting of 1 and -1. -/
def oneNegOneSubgroup : Subgroup Rˣ where
  carrier := {(1 : Rˣ), -1}
  one_mem' := by simp
  mul_mem' := by
    intro a b ha hb
    simp only [Set.mem_insert_iff, Set.mem_singleton_iff] at ha hb
    rcases ha with rfl|rfl <;> rcases hb with rfl|rfl <;> simp
  inv_mem' := by
    intro a ha
    simp only [Set.mem_insert_iff, Set.mem_singleton_iff] at ha
    rcases ha with rfl|rfl <;> simp

-- The theorem statement