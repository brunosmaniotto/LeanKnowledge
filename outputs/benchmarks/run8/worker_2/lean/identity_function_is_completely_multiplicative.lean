import Mathlib

open ArithmeticFunction

theorem Identity_Function_is_Completely_Multiplicative :
    IsMultiplicative (id : ArithmeticFunction ℕ) :=
  isMultiplicative_id