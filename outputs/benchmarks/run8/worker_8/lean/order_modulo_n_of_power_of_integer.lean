import Mathlib

theorem Order_Modulo_n_of_Power_of_Integer (n : ℕ) (a : (ZMod n)ˣ) (k : ℕ) :
    orderOf (a ^ k) = orderOf a / Nat.gcd (orderOf a) k := by
  rw [orderOf_pow]