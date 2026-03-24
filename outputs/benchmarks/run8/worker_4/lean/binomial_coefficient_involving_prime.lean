import Mathlib

-- Axiomatized sub-lemmas as given
axiom lucas_theorem_applied_to_p (n p : ℕ) (hp : Nat.Prime p) : n.choose p ≡ (n / p).choose (p / p) * (n % p).choose (p % p) [MOD p]
axiom choose_of_mod_self_is_one (m p : ℕ) : m.choose (p % p) = 1
axiom choose_of_div_self_is_self (m p : ℕ) (hp_pos : 0 < p) : m.choose (p / p) = m

-- Main theorem proving n.choose p ≡ n / p [MOD p] for a prime p
theorem binomial_coeff_prime_mod_p (n p : ℕ) (hp : Nat.Prime p) : n.choose p ≡ n / p [MOD p] := by
  -- Start with the congruence from the axiom based on Lucas's Theorem.
  have h_lucas := lucas_theorem_applied_to_p n p hp

  -- Simplify the RHS of h_lucas using the other two axioms.
  -- Note: hp.pos is valid because Nat.Prime p implies p > 0.
  have h_div := choose_of_div_self_is_self (n / p) p hp.pos
  have h_mod := choose_of_mod_self_is_one (n % p) p

  -- Substitute these simplifications into the congruence.
  rw [h_div, h_mod] at h_lucas

  -- Simplify the resulting multiplication by one.
  rw [mul_one] at h_lucas

  -- The congruence now matches the goal.
  exact h_lucas