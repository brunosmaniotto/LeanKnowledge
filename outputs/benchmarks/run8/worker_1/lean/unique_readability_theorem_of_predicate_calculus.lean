import Mathlib

variable (Term : Type)

inductive BinaryConnective
  | and | or | imp | iff

inductive Formula (Term : Type)
  | atomic : String → List Term → Formula Term
  | neg : Formula Term → Formula Term
  | binary : BinaryConnective → Formula Term → Formula Term → Formula Term
  | all : String → Formula Term → Formula Term
  | ex : String → Formula Term → Formula Term

def Formula.startsWithLeftBracketOrNeg {Term : Type} : Formula Term → Prop
  | Formula.neg _ => True
  | Formula.binary _ _ _ => True
  | _ => False