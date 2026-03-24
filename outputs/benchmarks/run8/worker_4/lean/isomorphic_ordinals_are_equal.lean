import Mathlib

open Ordinal

theorem isomorphic_ordinals_are_equal (a b : Ordinal) (h : Nonempty (a.out.r ≃r b.out.r)) : a = b := by
  rw [← Quotient.out_eq a, ← Quotient.out_eq b]
  exact Quotient.eq.mpr h