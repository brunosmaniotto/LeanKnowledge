import Mathlib

theorem nat_set_primrec : Primrec (fun (_ : ℕ) => 1) :=
  Primrec.const 1