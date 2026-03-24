import Mathlib
open LucasLehmer

theorem lucas_lehmer_test (q : ℕ) (hq : Nat.Prime q) (hq_odd : Odd q) : (mersenne q).Prime ↔ LucasLehmerTest q := by
  have hq1 : 1 < q := hq.one_lt
  have hq3 : 3 ≤ q := by
    have h2 : 2 ≤ q := hq.two_le
    by_contra! H
    have : q = 2 := by omega
    subst this
    have : ¬ Odd 2 := by decide
    exact this hq_odd
  constructor
  · intro h
    exact lucas_lehmer_necessity q hq3 h
  · intro h
    exact lucas_lehmer_sufficiency q hq1 h