import Mathlib

theorem euler_phi_multiplicative (m n : ℕ) (hm : m > 0) (hn : n > 0) (h : Nat.Coprime m n) :
    Nat.totient (m * n) = Nat.totient m * Nat.totient n :=
  Nat.totient_mul h