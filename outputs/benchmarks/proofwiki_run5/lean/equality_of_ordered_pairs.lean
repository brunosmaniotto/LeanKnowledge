import Mathlib

theorem ordered_pair_eq_iff {α β : Type*} (a c : α) (b d : β) : (a, b) = (c, d) ↔ a = c ∧ b = d :=
  Prod.ext_iff