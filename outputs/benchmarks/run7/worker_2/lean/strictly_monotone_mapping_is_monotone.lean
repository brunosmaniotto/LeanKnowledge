import Mathlib

theorem strict_monotone_imp_monotone {α β : Type _} [PartialOrder α] [Preorder β] {f : α → β}
    (h : StrictMono f ∨ StrictAnti f) : Monotone f ∨ Antitone f := by
  cases' h with h_inc h_dec
  · exact Or.inl h_inc.monotone
  · exact Or.inr h_dec.antitone