import Mathlib

theorem StrictMono.monotone_of_partialOrder [PartialOrder α] [Preorder β] {f : α → β} (hf : StrictMono f) :
    Monotone f := by
  intro a b h
  rcases eq_or_lt_of_le h with (rfl | hlt)
  · exact le_refl (f a)
  · exact le_of_lt (hf hlt)