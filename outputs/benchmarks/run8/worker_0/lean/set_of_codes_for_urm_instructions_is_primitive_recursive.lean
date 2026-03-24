import Mathlib.Computability.Primrec.List

open Primrec

variable {seq : ℕ → ℕ} (hseq : Primrec seq)
variable {len : ℕ → ℕ} (hlen : Primrec len)

-- Helper: equality to a constant as a ℕ-valued function (1 if equal, 0 otherwise)
def beq_const (c : ℕ) : ℕ → ℕ := fun n => if n = c then 1 else 0