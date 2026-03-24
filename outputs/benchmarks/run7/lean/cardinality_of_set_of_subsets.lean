import Mathlib

open Finset
open Nat

theorem card_subsets_eq_factorial_div {α : Type*} [DecidableEq α] (s : Finset α) (n : ℕ) (h : s.card = n) (hm : m ≤ n) :
    (s.powersetCard m).card = n ! / (m ! * (n - m)!) := by
  rw [card_powersetCard, h, Nat.choose_eq_factorial_div_factorial hm]