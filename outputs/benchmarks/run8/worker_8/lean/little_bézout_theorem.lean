import Mathlib

open Polynomial

theorem little_bezout (R : Type _) [CommRing R] (p : Polynomial R) (a : R) :
    p %ₘ (X - C a) = C (p.eval a) :=
  modByMonic_X_sub_C_eq_C_eval p a