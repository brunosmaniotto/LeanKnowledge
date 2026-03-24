import Mathlib

structure BinStruct where
  carrier : Type u
  op : carrier → carrier → carrier

theorem BinStruct.ext_iff (A B : BinStruct) :
    A = B ↔ ∃ (h_carrier : A.carrier = B.carrier),
      ∀ (a : A.carrier) (b : A.carrier),
        cast h_carrier (A.op a b) = B.op (cast h_carrier a) (cast h_carrier b) := by
  constructor
  · intro h
    subst h
    exact ⟨rfl, fun a b => rfl⟩
  · rintro ⟨h_carrier, h_op⟩
    cases A
    cases B
    simp at h_carrier
    subst h_carrier
    congr
    funext a b
    simp at h_op
    exact h_op a b