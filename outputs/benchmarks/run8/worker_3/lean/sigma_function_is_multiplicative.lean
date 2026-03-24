import Mathlib

open ArithmeticFunction

theorem sigma_is_multiplicative : IsMultiplicative (sigma 1) :=
  isMultiplicative_sigma (k := 1)