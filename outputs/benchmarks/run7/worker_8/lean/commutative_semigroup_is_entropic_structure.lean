import Mathlib

variable {S : Type u} [CommSemigroup S]

theorem CommSemigroup.entropic (a b c d : S) : (a * b) * (c * d) = (a * c) * (b * d) := by
  ac_rfl