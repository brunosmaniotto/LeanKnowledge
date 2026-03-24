import Mathlib

variable {R : Type _} [CommRing R] {m n : ℕ}

/-- Two matrices are row equivalent if there exists an invertible matrix P such that P * A = B. -/
def rowEquiv (A B : Matrix (Fin m) (Fin n) R) : Prop :=
  ∃ (P : Matrix (Fin m) (Fin m) R) (h : IsUnit P), P * A = B