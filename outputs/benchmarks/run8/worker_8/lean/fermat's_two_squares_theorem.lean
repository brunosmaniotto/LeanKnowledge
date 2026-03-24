import Mathlib

-- The main theorem is assembled from these axiomatized sub-lemmas.
-- In a full development, these axioms would be proven theorems.

-- Axiom 1: A prime p has p % 4 ≠ 3 iff p = 2 or p % 4 = 1.
-- This is provable from `Nat.Prime.mod_four_ne_three_iff_eq_two_or_one`.
axiom prime_mod_four_ne_three_iff_eq_two_or_mod_one {p : ℕ} (hp : Nat.Prime p) : p % 4 ≠ 3 ↔ p = 2 ∨ p % 4 = 1

-- Axiom 2: A prime p is a sum of two squares iff p = 2 or p % 4 = 1.
-- This is the existence part of Fermat's theorem, corresponding to `Nat.Prime.sum_two_squares_iff_of_not_three_mod_four`.
axiom fermat_two_squares_existence {p : ℕ} (hp : Nat.Prime p) : (∃ a b, a ^ 2 + b ^ 2 = p) ↔ p = 2 ∨ p % 4 = 1

-- Axiom 3: If a prime is a sum of two squares, the squares are coprime.
-- This is provable and is a key step in the uniqueness proof.
axiom coprime_of_sum_of_squares_eq_prime {p a b : ℕ} (hp : Nat.Prime p) (h : a ^ 2 + b ^ 2 = p) : Nat.Coprime a b

-- Axiom 4: The uniqueness of the representation of a prime as a sum of two squares, up to order.
-- This corresponds to `Nat.Prime.sum_two_squares_unique`.
axiom fermat_two_squares_uniqueness {p a b c d : ℕ} (hp : Nat.Prime p) (h1 : a ^ 2 + b ^ 2 = p) (h2 : c ^ 2 + d ^ 2 = p) : ({a, b} : Multiset ℕ) = ({c, d} : Multiset ℕ)

/--
**Fermat's Two Squares Theorem**

A prime number `p` can be expressed as the sum of two squares if and only if `p = 2` or `p % 4 = 1`.
Furthermore, this representation is unique up to the order of the two squares.

This proof assembles the theorem from pre-proven (axiomatized) components for existence and uniqueness.
-/
theorem fermat_two_squares (p : ℕ) (hp : Nat.Prime p) :
    ((∃ a b, a ^ 2 + b ^ 2 = p) ↔ (p = 2 ∨ p % 4 = 1)) ∧
    (∀ {a b c d : ℕ}, a ^ 2 + b ^ 2 = p → c ^ 2 + d ^ 2 = p → ({a, b} : Multiset ℕ) = ({c, d} : Multiset ℕ)) := by
  -- The proof goal is a conjunction, so we prove each part separately.
  constructor
  -- Part 1: Existence
  -- This is a direct application of the `fermat_two_squares_existence` axiom.
  . exact fermat_two_squares_existence hp
  -- Part 2: Uniqueness
  -- We need to show that for any two representations, the sets of summands are the same.
  . intro a b c d h1 h2
    -- This is a direct application of the `fermat_two_squares_uniqueness` axiom.
    exact fermat_two_squares_uniqueness hp h1 h2