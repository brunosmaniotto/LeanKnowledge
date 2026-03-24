import Mathlib

theorem euler_phi_prime_power (p n : ℕ) (hp : p.Prime) (hn : 0 < n) :
    Nat.totient (p ^ n) = p ^ n - p ^ (n - 1) ∧
    Nat.totient (p ^ n) = (p - 1) * p ^ (n - 1) := by
  have H := Nat.totient_prime_pow hp hn
  have H1 : Nat.totient (p ^ n) = p ^ n - p ^ (n - 1) := by
    rw [H, Nat.mul_sub_left_distrib, mul_one, ← pow_succ, Nat.sub_add_cancel (by omega)]
  have H2 : Nat.totient (p ^ n) = (p - 1) * p ^ (n - 1) := by
    rw [H, mul_comm]
  exact ⟨H1, H2⟩