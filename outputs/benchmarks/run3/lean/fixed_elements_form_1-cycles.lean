import Mathlib

theorem fixed_elements_form_one_cycles {α : Type*} [Fintype α] [DecidableEq α] 
    (π : Equiv.Perm α) (x : α) (hx : π x = x) : π.cycleOf x = 1 := by
  rw [Equiv.Perm.cycleOf_eq_one_iff]
  exact hx