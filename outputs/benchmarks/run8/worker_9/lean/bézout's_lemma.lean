import Mathlib

theorem bezout_lemma (a b : ℤ) (h : ¬ (a = 0 ∧ b = 0)) : ∃ x y : ℤ, a * x + b * y = (Int.gcd a b : ℤ) :=
  ⟨Int.gcdA a b, Int.gcdB a b, (Int.gcd_eq_gcd_ab a b).symm⟩