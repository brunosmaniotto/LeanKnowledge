import Mathlib

open Set
open Order

variable {S : Type} [LinearOrder S] [SuccOrder S]

theorem closed_interval_with_successor_eq_union (m n : S) (hmn : m ≤ n) :
    Icc m (succ n) = Icc m n ∪ {succ n} := by
  ext x
  constructor
  · intro ⟨hxm, hxsn⟩
    rcases le_iff_lt_or_eq.1 hxsn with (hxsn_lt | hxsn_eq)
    · have hxn : x ≤ n := le_of_lt_succ hxsn_lt
      exact Or.inl ⟨hxm, hxn⟩
    · exact Or.inr hxsn_eq
  · intro h
    rcases h with (⟨hxm, hxn⟩ | hx)
    · have hxsn : x ≤ succ n := le_trans hxn (le_succ n)
      exact ⟨hxm, hxsn⟩
    · rw [hx]
      have hmn' : m ≤ succ n := le_trans hmn (le_succ n)
      exact ⟨hmn', le_refl _⟩