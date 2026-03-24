import Mathlib

open Set

variable {α : Type*}

theorem set_diff_self (s : Set α) : s \ s = ∅ :=
  diff_self