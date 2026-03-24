import Mathlib

variable {S T : Type*} [LinearOrder S] [PartialOrder T]

theorem mapping_is_orderEmbedding_iff_strictly_increasing (φ : S → T) :
    (∀ x y : S, x ≤ y ↔ φ x ≤ φ y) ↔ StrictMono φ := by
  constructor
  · intro h_embed
    intro a b hab
    have h_le : a ≤ b := le_of_lt hab
    have h_ne : a ≠ b := ne_of_lt hab
    have h_φ_le : φ a ≤ φ b := (h_embed a b).mp h_le
    have h_φ_ne : φ a ≠ φ b := by
      intro h_eq
      have h_ge : b ≤ a := (h_embed b a).mpr (le_of_eq h_eq.symm)
      have h_eq_ab : a = b := le_antisymm h_le h_ge
      exact h_ne h_eq_ab
    exact lt_of_le_of_ne h_φ_le h_φ_ne
  · intro h_strict
    intro x y
    exact (StrictMono.le_iff_le h_strict).symm