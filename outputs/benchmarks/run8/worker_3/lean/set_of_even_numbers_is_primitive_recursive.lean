import Mathlib
open Nat
open Primrec

def evenChar : ℕ → ℕ := Nat.rec 1 (fun n y => 1 - y)