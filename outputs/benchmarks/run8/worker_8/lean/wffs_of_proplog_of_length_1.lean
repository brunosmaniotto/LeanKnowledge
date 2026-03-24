import Mathlib

variable {Var : Type}

inductive WFF (Var : Type)
  | var : Var → WFF Var
  | top : WFF Var
  | bot : WFF Var
  | and : WFF Var → WFF Var → WFF Var
  | or : WFF Var → WFF Var → WFF Var
  | imp : WFF Var → WFF Var → WFF Var
  | not : WFF Var → WFF Var

namespace WFF

def length : WFF Var → ℕ
  | var _ => 1
  | top => 1
  | bot => 1
  | and A B => 1 + A.length + B.length
  | or A B => 1 + A.length + B.length
  | imp A B => 1 + A.length + B.length
  | not A => 1 + A.length