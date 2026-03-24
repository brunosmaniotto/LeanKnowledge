import Mathlib

open Nat

lemma b_modEq_one (b : ℕ) (h : b > 1) : b ≡ 1 [MOD b - 1] :=
  Nat.modEq_sub (by omega)