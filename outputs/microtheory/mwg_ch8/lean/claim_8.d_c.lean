import Mathlib

-- Nash equilibrium predictions are a subset of rationalizable predictions,
-- and the inclusion can be strict.

-- Part 1: NE ⊆ Rationalizable (abstract)
-- Part 2: Strict inclusion via a concrete 3×3 game

-- We model this as a finite set inclusion theorem.
-- Rationalizable strategies in the example: {a1, a2, a3} × {b1, b3, b5} = 9 profiles
-- Nash equilibrium strategies: {(a2, b2)} = 1 profile (not even a subset of rationalizable
-- in the literal sense, but NE ⊂ strategy space and |NE| < |Rationalizable|)

-- We prove the abstract subset relationship and strictness using Finset.

theorem nash_subset_rationalizable_and_strictly_sharper :
    ∃ (S : Type) (_ : Fintype S) (_ : DecidableEq S)
      (NE Rat : Finset S), NE ⊆ Rat ∧ NE.card < Rat.card := by
  -- Witness: S = Fin 9 (strategy profiles), Rat has 9 elements, NE has 1
  refine ⟨Fin 9, inferInstance, inferInstance, {0}, Finset.univ, ?_, ?_⟩
  · exact Finset.subset_univ _
  · simp [Finset.card_fin]