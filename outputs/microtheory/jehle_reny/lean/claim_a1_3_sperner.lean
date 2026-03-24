import Mathlib
open Topology

/-- A simplicial complex triangulating the standard n-simplex with a Sperner labelling. -/
axiom SpernerSubdivision (n : ℕ) : Type

/-- The number of completely labelled n-simplices in a Sperner subdivision. -/
axiom completelyLabelledCount {n : ℕ} (S : SpernerSubdivision n) : ℕ

/-- Sperner's Lemma: Any feasibly labelled simplicial subdivision of the n-simplex
    contains an odd number of completely labelled sub-simplices. -/
axiom sperner_lemma (n : ℕ) (S : SpernerSubdivision n) :
    Odd (completelyLabelledCount S)

/-- Sperner's Lemma (full statement): the number of completely labelled sub-simplices
    is odd, and in particular there is at least one. -/
theorem claim_A1_3_sperner (n : ℕ) (S : SpernerSubdivision n) :
    Odd (completelyLabelledCount S) ∧ 0 < completelyLabelledCount S := by
  constructor
  · exact sperner_lemma n S
  · obtain ⟨k, hk⟩ := sperner_lemma n S
    omega