import Mathlib

open Complex
open Set

lemma isClosed_setOf_re_ge (a : ℝ) : IsClosed {z : ℂ | a ≤ z.re} := by
  exact isClosed_Ici.preimage continuous_re