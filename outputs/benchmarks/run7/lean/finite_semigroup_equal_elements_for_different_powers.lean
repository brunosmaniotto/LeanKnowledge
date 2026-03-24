import Mathlib

/-- The positive powers of an element in a semigroup: `x^(n+1)` for `n : ℕ`. -/
def semigroupPow {S : Type} [Semigroup S] (x : S) : ℕ → S :=
  fun n => Nat.recOn n x (fun _ prev => prev * x)