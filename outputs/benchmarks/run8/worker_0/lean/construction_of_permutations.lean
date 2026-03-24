import Mathlib

open Fintype

theorem card_perm_fin (n : ℕ) : Fintype.card (Equiv.Perm (Fin n)) = Nat.factorial n := by
  rw [Fintype.card_perm, Fintype.card_fin]