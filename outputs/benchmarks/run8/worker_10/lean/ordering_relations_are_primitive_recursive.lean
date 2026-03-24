import Mathlib

open Primrec

theorem lt_primrec : PrimrecRel (· < · : ℕ → ℕ → Prop) :=
  nat_lt