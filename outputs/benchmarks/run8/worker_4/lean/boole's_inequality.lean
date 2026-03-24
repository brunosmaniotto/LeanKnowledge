import Mathlib

open Finset
open MeasureTheory

theorem boole_inequality {Ω : Type u} [MeasurableSpace Ω] (μ : Measure Ω) (n : ℕ) (A : ℕ → Set Ω) :
    μ (⋃ i ∈ range n, A i) ≤ ∑ i ∈ range n, μ (A i) :=
  measure_biUnion_finset_le (range n) A