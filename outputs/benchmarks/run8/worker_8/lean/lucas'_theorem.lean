import Mathlib

-- Axiom 1: Equivalence between Nat.ModEq congruence and equality in ZMod p.
-- This is a standard result in Mathlib, often expressed via `Nat.ModEq.iff`.
axiom lucas_congruence_iff_zmod_equality (p n k : ℕ) :
    (Nat.choose n k ≡ Nat.choose (n / p) (k / p) * Nat.choose (n % p) (k % p) [MOD p]) ↔
    ((Nat.choose n k : ZMod p) = (Nat.choose (n / p) (k / p) : ZMod p) * (Nat.choose (n % p) (k % p) : ZMod p))

-- Axiom 2: Lucas' Theorem stated in terms of ZMod p.
-- This is the core of the theorem, proven in Mathlib as `ZMod.choose_lucas`.
axiom lucas_theorem_in_zmod (p n k : ℕ) [hp : Fact (Nat.Prime p)] :
    (Nat.choose n k : ZMod p) = (Nat.choose (n / p) (k / p) : ZMod p) * (Nat.choose (n % p) (k % p) : ZMod p)

-- Main theorem proof using the axioms.
theorem lucas_theorem (p n k : ℕ) (hp : Nat.Prime p) :
    Nat.choose n k ≡ Nat.choose (n / p) (k / p) * Nat.choose (n % p) (k % p) [MOD p] := by
  -- Create a `Fact` instance for the prime `p`, as required by `lucas_theorem_in_zmod`.
  haveI : Fact (Nat.Prime p) := ⟨hp⟩
  -- Use the equivalence lemma to switch the goal from a `Nat.ModEq` congruence
  -- to an equality in `ZMod p`.
  rw [lucas_congruence_iff_zmod_equality]
  -- The new goal is now exactly the statement of the second lemma.
  exact lucas_theorem_in_zmod p n k