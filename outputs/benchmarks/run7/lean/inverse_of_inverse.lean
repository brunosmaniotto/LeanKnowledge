import Mathlib.Data.Rel

theorem inverse_of_inverse {α β : Type _} (r : Rel α β) : flip (flip r) = r := by
  ext x y
  rfl