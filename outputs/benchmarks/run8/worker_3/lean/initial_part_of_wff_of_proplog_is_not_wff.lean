import Mathlib.Data.List.Basic
import Mathlib.Data.Int.Basic

inductive Token : Type
  | atom : ℕ → Token
  | left_paren : Token
  | right_paren : Token
  | impl : Token
  | neg : Token

inductive WFF : Type
  | atom : ℕ → WFF
  | neg : WFF → WFF
  | impl : WFF → WFF → WFF

def tokens : WFF → List Token
  | WFF.atom n => [Token.atom n]
  | WFF.neg p => [Token.left_paren, Token.neg] ++ tokens p ++ [Token.right_paren]
  | WFF.impl p q => [Token.left_paren] ++ tokens p ++ [Token.impl] ++ tokens q ++ [Token.right_paren]