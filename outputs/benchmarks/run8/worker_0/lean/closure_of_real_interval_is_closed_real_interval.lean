import Mathlib
open Set

theorem closure_interval (a b : ℝ) (I : Set ℝ) 
    (hI : I = Ioo a b ∨ I = Ico a b ∨ I = Ioc a b ∨ I = Icc a b)
    (hI_nonempty : Set.Nonempty I) : closure I = Icc a b := by
  rcases hI with (rfl|rfl|rfl|rfl)
  · -- Case I = Ioo a b
    rcases hI_nonempty with ⟨x, hx⟩
    have h : a < b := lt_trans hx.left hx.right
    have h_ne : a ≠ b := ne_of_lt h
    exact closure_Ioo h_ne
  · -- Case I = Ico a b
    rcases hI_nonempty with ⟨x, hx⟩
    have h : a < b := lt_of_le_of_lt hx.left hx.right
    have h_ne : a ≠ b := ne_of_lt h
    exact closure_Ico h_ne
  · -- Case I = Ioc a b
    rcases hI_nonempty with ⟨x, hx⟩
    have h : a < b := lt_of_lt_of_le hx.left hx.right
    have h_ne : a ≠ b := ne_of_lt h
    exact closure_Ioc h_ne
  · -- Case I = Icc a b
    exact closure_Icc a b