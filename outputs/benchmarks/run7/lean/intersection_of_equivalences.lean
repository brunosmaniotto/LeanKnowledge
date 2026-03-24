import Mathlib

namespace Setoid

/-- The intersection of two equivalence relations is an equivalence relation. -/
def inter (r s : Setoid α) : Setoid α where
  r x y := r.r x y ∧ s.r x y
  iseqv := {
    refl := fun x => ⟨r.refl x, s.refl x⟩
    symm := fun h => ⟨r.symm h.1, s.symm h.2⟩
    trans := fun h1 h2 => ⟨r.trans h1.1 h2.1, s.trans h1.2 h2.2⟩
  }

end Setoid