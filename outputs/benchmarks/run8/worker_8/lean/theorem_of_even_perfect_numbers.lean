import Mathlib

open ArithmeticFunction

-- A natural number is perfect if the sum of its divisors (including itself) equals twice the number
def IsPerfect (n : ℕ) : Prop := (sigma 1) n = 2 * n

-- Necessary condition: every even perfect number has the form 2^(n-1)*(2^n - 1) with 2^n - 1 prime