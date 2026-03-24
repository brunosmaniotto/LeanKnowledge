import Mathlib

theorem trivial_quotient_bijection (S : Type _) :
    Function.Bijective (Quotient.mk (Setoid.ker (id : S → S))) := by
  constructor
  · intro x y h
    exact Quotient.eq.1 h
  · intro q
    refine Quotient.inductionOn q (fun x => ⟨x, rfl⟩)