import Mathlib

theorem countable_union_of_countable_sets (S : ℕ → Set α) (h : ∀ n, (S n).Countable) : (⋃ n, S n).Countable :=
  Set.countable_iUnion h