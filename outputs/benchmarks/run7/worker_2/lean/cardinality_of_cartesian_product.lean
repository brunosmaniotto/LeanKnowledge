import Mathlib

open Set

theorem card_cartesian_product (S : Set α) (T : Set β) :
    Nat.card (S ×ˢ T) = Nat.card S * Nat.card T := by
  calc
    Nat.card (S ×ˢ T) = Nat.card (S × T) := by
      rw [Nat.card_congr (Equiv.Set.prod S T)]
    _ = Nat.card S * Nat.card T := Nat.card_prod S T