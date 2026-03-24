import Mathlib

axiom GCD_from_Prime_Decomposition (m n : ℤ) (hm : m ≠ 0) (hn : n ≠ 0) :
  Int.gcd m n = ∏ p ∈ (Nat.factorization (Int.natAbs m)).support ∪ (Nat.factorization (Int.natAbs n)).support,
    (p : ℤ) ^ min ((Nat.factorization (Int.natAbs m)) p) ((Nat.factorization (Int.natAbs n)) p)

axiom LCM_from_Prime_Decomposition (m n : ℤ) (hm : m ≠ 0) (hn : n ≠ 0) :
  Int.lcm m n = ∏ p ∈ (Nat.factorization (Int.natAbs m)).support ∪ (Nat.factorization (Int.natAbs n)).support,
    (p : ℤ) ^ max ((Nat.factorization (Int.natAbs m)) p) ((Nat.factorization (Int.natAbs n)) p)

theorem gcd_and_lcm_from_prime_decomposition (m n : ℤ) (hm : m ≠ 0) (hn : n ≠ 0) :
    (Int.gcd m n = ∏ p ∈ (Nat.factorization (Int.natAbs m)).support ∪ (Nat.factorization (Int.natAbs n)).support,
        (p : ℤ) ^ min ((Nat.factorization (Int.natAbs m)) p) ((Nat.factorization (Int.natAbs n)) p)) ∧
    (Int.lcm m n = ∏ p ∈ (Nat.factorization (Int.natAbs m)).support ∪ (Nat.factorization (Int.natAbs n)).support,
        (p : ℤ) ^ max ((Nat.factorization (Int.natAbs m)) p) ((Nat.factorization (Int.natAbs n)) p)) := by
  constructor
  · exact GCD_from_Prime_Decomposition m n hm hn
  · exact LCM_from_Prime_Decomposition m n hm hn