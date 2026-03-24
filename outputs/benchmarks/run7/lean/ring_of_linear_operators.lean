import Mathlib

theorem ring_of_linear_operators (R G : Type*) [Ring R] [AddCommGroup G] [Module R G] :
    Nonempty (Ring (Module.End R G)) :=
  ⟨inferInstance⟩