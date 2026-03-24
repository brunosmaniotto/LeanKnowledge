import Mathlib.Computability.Primrec

open Primrec

/-- The divisor counting function τ(n) = number of divisors of n. -/
def divisorCount (n : ℕ) : ℕ :=
  Nat.rec 0 (fun i acc => acc + if (i + 1) ∣ n then 1 else 0) n