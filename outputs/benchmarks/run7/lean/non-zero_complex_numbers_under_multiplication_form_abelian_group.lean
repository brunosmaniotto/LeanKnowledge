import Mathlib

/-!
# The non-zero complex numbers form an infinite abelian group

This file proves that the set of non-zero complex numbers, denoted `ℂˣ`,
forms an infinite abelian group under multiplication.

The proof is structured as follows:
1.  `nat_to_nonzero_complex_injection`: A helper lemma showing that the function
    `f(n) = (n : ℂ) + 1` is an injective map from `ℕ` to `ℂˣ`.
2.  `non_zero_complex_is_infinite_abelian_group`: The main theorem, which uses the
    helper lemma to establish the infinity of the group.

The group properties (closure, associativity, identity, inverse, commutativity)
are handled by Mathlib's typeclass system. `ℂ` is a `Field`, and the `Units` of any
`CommRing` (and thus any `Field`) automatically form a `CommGroup`.
-/

-- Sub-lemma proving injectivity of the map n ↦ n + 1 from ℕ to ℂˣ.
lemma nat_to_nonzero_complex_injection :
    Function.Injective (fun n : ℕ ↦ Units.mk0 ((n : ℂ) + 1) (Nat.cast_add_one_ne_zero n)) := by
  -- To prove injectivity, let n and m be natural numbers and assume f(n) = f(m).
  intro n m h
  -- The equality of units (type `ℂˣ`) implies the equality of their underlying values in `ℂ`.
  -- `Units.mk0_inj` simplifies `Units.mk0 x _ = Units.mk0 y _` to `x = y`.
  -- `simp` also cancels the `+ 1` on both sides using `add_right_cancel`.
  simp [Units.mk0_inj] at h
  -- Now `h` is `(↑n : ℂ) = (↑m : ℂ)`.
  -- Since casting from `ℕ` to `ℂ` is injective, this implies `n = m`.
  -- The relevant lemma is `Nat.cast_injective`.
  exact Nat.cast_injective h

-- Main theorem: The non-zero complex numbers form an infinite abelian group.
-- We model this using `ℂˣ`, the group of units of the complex numbers.