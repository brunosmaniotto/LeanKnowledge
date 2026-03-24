import Mathlib

theorem card_compl {α : Type*} [DecidableEq α] (S T : Finset α) (h : T ⊆ S) (n m : ℕ) (hn : S.card = n) (hm : T.card = m) :
    (S \ T).card = n - m := by
  have hcard := Finset.card_sdiff_add_card_eq_card h
  rw [hn, hm] at hcard
  omega