import Mathlib

lemma gcd_abs_left (a b : ℤ) : Int.gcd (|a|) b = Int.gcd a b := by
  rw [Int.gcd_def, Int.gcd_def, Int.natAbs_abs]