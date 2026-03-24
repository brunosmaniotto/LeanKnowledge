import Mathlib

/-!
This file proves that for an integer `m ≥ 2`, the ring of integers modulo `m`
(`ℤ_m`, represented as `ℤ ⧸ Ideal.span {m}`) is a field if and only if `m` is a prime number.

The proof is assembled from several key lemmas:
1. The ring `ℤ ⧸ Ideal.span {m}` is isomorphic to `ZMod (Int.natAbs m)`.
2. The `IsField` property is preserved under ring isomorphisms.
3. Primality for an integer `m` is equivalent to primality for its natural absolute value `|m|`.
4. `ZMod n` is a field if and only if `n` is a prime number (`Nat.Prime n`).
-/

-- Proved sub-lemma 1: Isomorphism between ℤ/mℤ and ZMod |m|
/-
This lemma states that the ring of integers modulo an integer `m`,
which is `ℤ ⧸ Ideal.span {m}`, is ring-isomorphic to `ZMod n`
where `n` is the natural number absolute value of `m`.

The proof is by exhibiting the specific ring equivalence from Mathlib,
`Int.quotientSpanEquivZMod m`, which directly proves the existence
of such an isomorphism.
-/
lemma ring_iso_z_mod_m_to_zmod_nat_abs (m : ℤ) : Nonempty ((ℤ ⧸ Ideal.span {m}) ≃+* ZMod (Int.natAbs m)) := by
  exact ⟨Int.quotientSpanEquivZMod m⟩

-- Proved sub-lemma 2: Equivalence of primality for ℤ and ℕ
/-
This lemma states that an integer `m` is prime if and only if its
natural number absolute value `|m|` is prime. This connects `Prime m`
on integers to `Nat.Prime` on natural numbers.
-/