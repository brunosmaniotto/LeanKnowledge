import Mathlib

instance [Finite α] [LinearOrder α] : IsWellOrder α (· < ·) where
  wf := Finite.wellFounded_of_trans_of_irrefl _