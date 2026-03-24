import Mathlib

variable (seqChar seqLen : ℕ → ℕ) (seqGet : ℕ → ℕ → ℕ) (instrChar : ℕ → ℕ)
variable (h_seqChar : Primrec seqChar) (h_seqLen : Primrec seqLen) (h_seqGet : Primrec₂ seqGet) (h_instrChar : Primrec instrChar)

def g : ℕ → ℕ → ℕ :=
  fun n z => Nat.rec 1 (fun k IH => IH * instrChar (seqGet n (k + 1))) z