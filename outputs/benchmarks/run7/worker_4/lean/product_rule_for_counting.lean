import Mathlib

open Finset

theorem product_rule_counting {A B : Type*} (s : Finset A) (t : Finset B) (m n : ℕ)
    (hm : s.card = m) (hn : t.card = n) : (s ×ˢ t).card = m * n := by
  rw [card_product s t, hm, hn]