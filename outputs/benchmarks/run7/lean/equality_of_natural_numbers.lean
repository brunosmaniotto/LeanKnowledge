import Mathlib

open Set

theorem set_equiv_Iio_iff (m n : ℕ) : Nonempty (Equiv (↥(Set.Iio m)) (↥(Set.Iio n))) ↔ m = n := by
  constructor
  · intro h
    rcases h with ⟨e⟩
    have card_eq : Fintype.card (↥(Set.Iio m)) = Fintype.card (↥(Set.Iio n)) := Fintype.card_congr e
    simp at card_eq
    exact card_eq
  · intro h
    subst h
    exact ⟨Equiv.refl _⟩