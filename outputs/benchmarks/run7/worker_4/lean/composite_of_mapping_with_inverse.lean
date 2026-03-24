import Mathlib

variable {S T : Type*}

theorem comp_inv_self_eq_equiv_class (f : S → T) (x : S) :
    f ⁻¹' (f '' {x}) = { y : S | f y = f x } := by
  ext y
  simp