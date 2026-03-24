import Mathlib

theorem StrictAnti.antitone' [PartialOrder α] [Preorder β] {f : α → β} (hf : StrictAnti f) :
    Antitone f := by
  intro a b h
  rcases eq_or_lt_of_le h with (rfl | hlt)
  · rfl
  · exact le_of_lt (hf hlt)