import Mathlib

/-!
# Order of the Symmetric Group

This file proves that the order of the symmetric group on a finite set `S` of cardinality `n`
is `n!`. The proof is structured by assembling two helper lemmas as requested.
-/

-- Proved sub-lemma 1: The cardinality of the permutation group on S is (card S)!.
-- This requires decidable equality on S.
theorem card_perm_of_decidable_eq (S : Type*) [Fintype S] [DecidableEq S] :
    Fintype.card (Equiv.Perm S) = Nat.factorial (Fintype.card S) := by
  -- The goal is identical to the Mathlib lemma `Fintype.card_perm`.
  exact Fintype.card_perm

-- Proved sub-lemma 2: A helper lemma to perform substitution.
-- If `card (Perm S) = (card S)!` and `card S = n`, then `card (Perm S) = n!`.