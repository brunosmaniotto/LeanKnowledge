import Mathlib

variable {S : Type} [LinearOrder S]

theorem has_least_and_greatest_element (T : Finset S) (hT : T.Nonempty) :
    (∃ m ∈ T, ∀ x ∈ T, m ≤ x) ∧ (∃ m ∈ T, ∀ x ∈ T, x ≤ m) := by
  constructor
  · exact ⟨T.min' hT, T.min'_mem hT, fun x hx => Finset.min'_le T x hx⟩
  · exact ⟨T.max' hT, T.max'_mem hT, fun x hx => Finset.le_max' T x hx⟩