import Mathlib

theorem fermat_little {p : ℕ} (hp : p.Prime) (n : ℕ) (hn : ¬ p ∣ n) : n ^ (p - 1) ≡ 1 [MOD p] := by
  have h : Nat.Coprime p n := hp.coprime_iff_not_dvd.mpr hn
  have h' : Nat.Coprime n p := Nat.Coprime.symm h
  calc
    n ^ (p - 1) = n ^ (Nat.totient p) := by rw [Nat.totient_prime hp]
    _ ≡ 1 [MOD p] := Nat.ModEq.pow_totient h'