import Mathlib

theorem Product_of_r_Choose_m_with_m_Choose_k (r m k : ℕ) (hm : m ≤ r) (hk : k ≤ m) :
    Nat.choose r m * Nat.choose m k = Nat.choose r k * Nat.choose (r - k) (m - k) := by
  apply Nat.choose_mul <;> assumption