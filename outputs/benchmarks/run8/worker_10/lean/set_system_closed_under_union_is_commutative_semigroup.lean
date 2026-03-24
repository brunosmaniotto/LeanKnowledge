import Mathlib

def set_system_comm_semigroup {α : Type _} (S : Set (Set α)) (h : ∀ A ∈ S, ∀ B ∈ S, A ∪ B ∈ S) :
    CommSemigroup (Subtype S) :=
  { mul := fun A B => ⟨A.1 ∪ B.1, h A.1 A.2 B.1 B.2⟩
    mul_assoc := fun A B C => Subtype.ext (Set.union_assoc A.1 B.1 C.1)
    mul_comm := fun A B => Subtype.ext (Set.union_comm A.1 B.1) }