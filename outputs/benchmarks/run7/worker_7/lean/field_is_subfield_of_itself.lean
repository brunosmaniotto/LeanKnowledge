import Mathlib

theorem field_is_subfield_self (F : Type _) [Field F] : ∃ (s : Subfield F), s.carrier = Set.univ :=
  ⟨⊤, rfl⟩