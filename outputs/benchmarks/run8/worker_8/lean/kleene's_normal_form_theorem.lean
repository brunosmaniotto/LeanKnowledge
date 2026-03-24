import Mathlib

open Nat.Partrec.Code
open Nat

noncomputable section

def U (z : ℕ) : ℕ := (unpair z).1