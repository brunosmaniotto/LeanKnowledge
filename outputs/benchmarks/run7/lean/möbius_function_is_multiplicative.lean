import Mathlib.NumberTheory.ArithmeticFunction.Moebius

open ArithmeticFunction

theorem möbius_function_is_multiplicative {m n : ℕ} (h : Nat.Coprime m n) :
    moebius (m * n) = moebius m * moebius n :=
  isMultiplicative_moebius.map_mul_of_coprime h