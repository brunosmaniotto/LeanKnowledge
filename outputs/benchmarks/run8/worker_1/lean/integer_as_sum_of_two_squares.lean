import Mathlib

theorem integer_as_sum_of_two_squares (n : ℕ) (hn : n > 0) :
    (∃ a b : ℕ, n = a ^ 2 + b ^ 2) ↔ ∀ p, Nat.Prime p → p % 4 = 3 → Even (padicValNat p n) := by
  rw [Nat.eq_sq_add_sq_iff]
  constructor
  · intro h p hp hmod
    by_cases hdiv : p ∣ n
    · have hmem : p ∈ n.primeFactors := by
        rw [Nat.mem_primeFactors]
        exact ⟨hp, hdiv, hn.ne.symm⟩
      exact h p hmem hmod
    · rw [padicValNat.eq_zero_of_not_dvd hdiv]
      exact ⟨0, by simp⟩
  · intro h q hq hmod
    rw [Nat.mem_primeFactors] at hq
    rcases hq with ⟨hq_prime, hq_div, _⟩
    exact h q hq_prime hmod