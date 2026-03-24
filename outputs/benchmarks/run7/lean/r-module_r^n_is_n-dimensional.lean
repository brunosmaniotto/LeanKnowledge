import Mathlib

theorem rank_R_pow (n : ℕ) [CommRing R] [Nontrivial R] : Module.rank R ((Fin n) → R) = (n : Cardinal) := by
  simpa [Fintype.card_fin] using rank_fun R (Fin n)