import Mathlib

variable {α : Type*} {n : ℕ}

theorem card_powerset (S : Set α) [Fintype S] (h : Fintype.card S = n) : Fintype.card (Set S) = 2 ^ n := by
  rw [Fintype.card_set, h]