import Mathlib
open Finset

noncomputable def gloveValue (S : Finset (Fin 3)) : ℚ :=
  if (2 : Fin 3) ∈ S ∧ ((0 : Fin 3) ∈ S ∨ (1 : Fin 3) ∈ S) then 1 else 0

def inCore (u : Fin 3 → ℚ) : Prop :=
  (∀ i, 0 ≤ u i) ∧
  Finset.sum Finset.univ u = 1 ∧
  ∀ S : Finset (Fin 3), gloveValue S ≤ Finset.sum S u