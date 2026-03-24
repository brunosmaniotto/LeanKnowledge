import Mathlib

theorem rational_vector_space (n : ℕ) : Nonempty (Module ℚ (Fin n → ℚ)) :=
  ⟨inferInstance⟩