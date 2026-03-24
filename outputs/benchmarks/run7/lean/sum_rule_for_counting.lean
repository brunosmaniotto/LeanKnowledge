import Mathlib

open Finset
open BigOperators

theorem sum_rule_for_counting (m : ℕ) (S : Fin m → Finset α) :
    Fintype.card (Σ i : Fin m, S i) = ∑ i : Fin m, (S i).card := by
  rw [Fintype.card_sigma]
  simp