import Mathlib

theorem irrational_sqrt_prime {p : ℕ} (hp : Nat.Prime p) : Irrational (Real.sqrt p) :=
  hp.irrational_sqrt