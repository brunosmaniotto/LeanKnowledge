import Mathlib

theorem divisor_iff_subset (m : ℤ) (hm : 0 < m) (n : ℤ) : m ∣ n ↔ (Ideal.span {n} : Ideal ℤ) ≤ Ideal.span {m} :=
  Ideal.span_singleton_le_span_singleton.symm