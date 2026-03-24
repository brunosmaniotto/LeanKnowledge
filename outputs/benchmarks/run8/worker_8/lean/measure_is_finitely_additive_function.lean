import Mathlib

open MeasureTheory Set Finset

theorem measure_is_finitely_additive {X : Type*} [MeasurableSpace X] (μ : Measure X)
    (A : Finset (Set X)) (h_meas : ∀ s ∈ A, MeasurableSet s)
    (h_disjoint : (A : Set (Set X)).Pairwise Disjoint) :
    μ (⋃ s ∈ A, s) = ∑ s ∈ A, μ s := by
  exact measure_biUnion_finset h_disjoint h_meas