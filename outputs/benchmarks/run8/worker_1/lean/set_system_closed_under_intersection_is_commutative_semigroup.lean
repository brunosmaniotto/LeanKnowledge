import Mathlib

variable {α : Type*} (S : Set (Set α)) (h_closed : ∀ A ∈ S, ∀ B ∈ S, A ∩ B ∈ S)

/-- The type of sets in S, with intersection as the multiplication. -/
def SetSystem : Type _ := Subtype (· ∈ S)

instance : CommSemigroup (SetSystem S) where
  mul a b := ⟨a.val ∩ b.val, h_closed a.val a.property b.val b.property⟩
  mul_assoc a b c := Subtype.ext (Set.inter_assoc a.val b.val c.val)
  mul_comm a b := Subtype.ext (Set.inter_comm a.val b.val)