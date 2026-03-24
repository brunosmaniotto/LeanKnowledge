import Mathlib

theorem fermat_little_theorem (p : ℕ) (hp : Nat.Prime p) (n : ℕ) (hn_pos : n > 0) (hndiv : ¬ p ∣ n) : n ^ (p - 1) ≡ 1 [MOD p] := by
  have coprime : Nat.Coprime n p :=
    Nat.Coprime.symm (hp.coprime_iff_not_dvd.mpr hndiv)
  have totient_eq : Nat.totient p = p - 1 := Nat.totient_prime hp
  calc
    n ^ (p - 1) = n ^ (Nat.totient p) := by rw [totient_eq]
    _ ≡ 1 [MOD p] := Nat.ModEq.pow_totient coprime