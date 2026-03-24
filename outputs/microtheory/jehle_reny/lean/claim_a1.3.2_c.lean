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

/-- Corollary: there is at least one completely labelled sub-simplex. -/
theorem sperner_lemma_at_least_one (n : ℕ) (S : SpernerSubdivision n) :
    0 < completelyLabelledCount S := by
  obtain ⟨k, hk⟩ := sperner_lemma n S
  omega