import Mathlib

structure MagmaBund where
  α : Type u
  mul : Mul α

instance : CoeSort MagmaBund (Type u) := ⟨MagmaBund.α⟩
instance (A : MagmaBund) : Mul A := A.mul

theorem isomorphism_is_equivalence_relation (M : Set MagmaBund) :
    Equivalence (fun (A B : M) => Nonempty (MulEquiv (A : MagmaBund) (B : MagmaBund))) := by
  constructor
  · intro A
    exact ⟨MulEquiv.refl A⟩
  · intro A B ⟨e⟩
    exact ⟨e.symm⟩
  · intro A B C ⟨e1⟩ ⟨e2⟩
    exact ⟨e1.trans e2⟩