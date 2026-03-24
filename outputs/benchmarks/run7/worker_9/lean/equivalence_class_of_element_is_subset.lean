import Mathlib

variable {α : Type*} {S : Set α} {R : α → α → Prop}

theorem equiv_class_subset (h : ∀ {x y}, R x y → x ∈ S ∧ y ∈ S) (x : α) : {y | R x y} ⊆ S := by
  intro y hy
  exact (h hy).right