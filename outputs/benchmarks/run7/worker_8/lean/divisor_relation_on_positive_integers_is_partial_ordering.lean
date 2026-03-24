import Mathlib.Data.PNat.Basic
import Mathlib.Order.Basic

instance : PartialOrder PNat where
  le a b := a ∣ b
  lt a b := a ∣ b ∧ ¬b ∣ a
  le_refl a := by
    exact dvd_refl a
  le_trans a b c := dvd_trans
  le_antisymm a b hab hba := by
    exact PNat.dvd_antisymm hab hba
  lt_iff_le_not_ge a b := by
    constructor
    · intro ⟨hle, hnge⟩
      exact ⟨hle, hnge⟩
    · intro ⟨hle, hnge⟩
      exact ⟨hle, hnge⟩