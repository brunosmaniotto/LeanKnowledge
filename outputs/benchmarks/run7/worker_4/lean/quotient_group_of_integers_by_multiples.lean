import Mathlib

/-!
# Quotient Group of Integers by Multiples

This file proves that the quotient group of the additive group of integers `ℤ` by the subgroup
of multiples of an integer `m` is isomorphic to the additive group of integers modulo `|m|`.
It also proves that the index of the subgroup `mℤ` in `ℤ` is `|m|`.

The main theorem is `int_quotient_zmultiples`, which is proven by assembling three sub-lemmas.
-/

-- Sub-lemma 1: The quotient group ℤ/mℤ is isomorphic to the additive group of integers modulo |m|.
-- This is a direct result from Mathlib's `Int.quotientZMultiplesEquivZMod`.
lemma quotient_zmultiples_isomorphic_to_zmod (m : ℤ) :
    Nonempty ((ℤ ⧸ AddSubgroup.zmultiples m) ≃+ ZMod (Int.natAbs m)) := by
  exact ⟨Int.quotientZMultiplesEquivZMod m⟩

-- Sub-lemma 2: The index of the subgroup mℤ is the cardinality of the group ℤ_|m|.
-- This follows from the definition of index and the isomorphism from the first sub-lemma.