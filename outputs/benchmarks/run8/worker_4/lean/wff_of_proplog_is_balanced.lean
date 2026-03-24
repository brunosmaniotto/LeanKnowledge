import Mathlib

-- The following definitions represent the structure of Well-Formed Formulas (WFFs)
-- and functions to count brackets in their string representation.

inductive PropForm (p : Type) where
  | var   : p → PropForm p
  | bot   : PropForm p
  | top   : PropForm p
  | neg   : PropForm p → PropForm p
  | and   : PropForm p → PropForm p → PropForm p
  | or    : PropForm p → PropForm p → PropForm p
  | imp   : PropForm p → PropForm p → PropForm p

-- Function to count left brackets '(' in the string representation.
def countL {p : Type} : PropForm p → Nat
  | .var _ => 0
  | .bot   => 0
  | .top   => 0
  | .neg A => countL A
  | .and A B => 1 + countL A + countL B
  | .or A B  => 1 + countL A + countL B
  | .imp A B => 1 + countL A + countL B

-- Function to count right brackets ')' in the string representation.