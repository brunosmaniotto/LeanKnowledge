import Mathlib

open String

inductive Formula : Type
  | atomic : ℕ → Formula
  | neg : Formula → Formula
  | and : Formula → Formula → Formula
  | or : Formula → Formula → Formula
  | imp : Formula → Formula → Formula
  | forall_quant : ℕ → Formula → Formula
  | exists_quant : ℕ → Formula → Formula

def Formula.repr : Formula → String
  | .atomic x => s! "p({x})"
  | .neg A => s! "¬{A.repr}"
  | .and A B => s! "({A.repr} ∧ {B.repr})"
  | .or A B => s! "({A.repr} ∨ {B.repr})"
  | .imp A B => s! "({A.repr} → {B.repr})"
  | .forall_quant x A => s! "(∀ {x}: {A.repr})"
  | .exists_quant x A => s! "(∃ {x}: {A.repr})"

-- Definition of proper prefix for strings