import Mathlib

open Computability

theorem linear_primrec (a b : ℕ) : Primrec (fun (n : ℕ) => a * n + b) := by
  -- Constant function for a
  have ha : Primrec (fun (_ : ℕ) => a) := Primrec.const a
  -- Constant function for b
  have hb : Primrec (fun (_ : ℕ) => b) := Primrec.const b
  -- Identity function (projection)
  have hid : Primrec (fun (n : ℕ) => n) := Primrec.id
  -- Multiplication is primitive recursive
  have hmul : Primrec₂ (fun (x y : ℕ) => x * y) := Primrec.nat_mul
  -- Addition is primitive recursive
  have hadd : Primrec₂ (fun (x y : ℕ) => x + y) := Primrec.nat_add
  -- Compose: first compute a * n
  have h1 : Primrec (fun (n : ℕ) => a * n) :=
    hmul.comp ha hid
  -- Then compute (a * n) + b
  exact hadd.comp h1 hb