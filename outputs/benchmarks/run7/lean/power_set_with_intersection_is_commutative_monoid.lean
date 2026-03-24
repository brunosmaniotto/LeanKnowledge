import Mathlib

open Set

variable {α : Type u}

def PowerSet (S : Set α) : Type u := { A : Set α // A ⊆ S }

namespace PowerSet

variable (S : Set α)

instance : Mul (PowerSet S) where
  mul A B := ⟨A.1 ∩ B.1, by
    intro x hx
    exact A.2 hx.1⟩

instance : One (PowerSet S) where
  one := ⟨S, by intro x hx; exact hx⟩

instance : CommMonoid (PowerSet S) where
  mul_comm A B := Subtype.ext (Set.inter_comm A.1 B.1)
  mul_assoc A B C := Subtype.ext (Set.inter_assoc A.1 B.1 C.1)
  one_mul A := Subtype.ext (Set.inter_eq_right.2 A.2)
  mul_one A := Subtype.ext (Set.inter_eq_left.2 A.2)