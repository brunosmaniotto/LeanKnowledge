import Mathlib

theorem constant_function_primrec (c : ℕ) : Primrec (fun (_ : ℕ) => c) :=
  Primrec.const c