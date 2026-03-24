import Mathlib

theorem diagonal_is_universally_compatible (S : Type) (I : Type) (f : (I → S) → S) :
    ∀ (x y : I → S), (∀ i, x i = y i) → f x = f y := by
  intro x y h
  have hxy : x = y := funext h
  rw [hxy]