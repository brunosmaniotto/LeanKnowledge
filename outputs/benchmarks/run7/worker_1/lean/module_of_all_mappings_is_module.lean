import Mathlib

theorem module_of_all_mappings (R : Type u) [Ring R] (G : Type v) [AddCommGroup G] [Module R G]
    (S : Type w) : Nonempty (Module R (S → G)) :=
  ⟨inferInstance⟩