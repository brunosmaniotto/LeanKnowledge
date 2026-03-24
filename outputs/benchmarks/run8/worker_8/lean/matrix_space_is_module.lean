import Mathlib

theorem matrix_space_is_module (R : Type u) [Ring R] (m n : ℕ) :
    Nonempty (Module R (Matrix (Fin m) (Fin n) R)) :=
  ⟨inferInstance⟩