import Mathlib

open Primrec

theorem subst_const_first_binary {a : ℕ} {f : ℕ → ℕ → ℕ} (hf : Primrec₂ f) : Primrec (fun x => f a x) :=
  Primrec₂.comp hf (const a) Primrec.id