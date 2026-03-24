import Mathlib

-- The prompt asks to prove that the power set of a non-empty set S,
-- with the symmetric difference operation, forms an abelian group.
-- We first prove the necessary properties of symmetric difference as separate lemmas,
-- then assemble them into the main proof.

-- step1_symmDiff_is_commutative: The operation is commutative.
lemma step1_symmDiff_is_commutative {α : Type*} (A B : Set α) : symmDiff A B = symmDiff B A := by
  -- The notation `A ∆ B` is scoped; `symmDiff A B` is the standard name.
  -- The lemma `symmDiff_comm` directly states this equality. We can use `rw` to apply it.
  rw [symmDiff_comm]

-- step2_symmDiff_is_associative: The operation is associative.