import Mathlib

open MeasureTheory Topology Filter
open Topology

theorem average_demand_continuous
    {P Θ : Type*} [TopologicalSpace P] [FirstCountableTopology P] [MeasurableSpace Θ]
    (μ : Measure Θ) [IsFiniteMeasure μ]
    (d : P → Θ → ℝ)
    (hm : ∀ p, AEStronglyMeasurable (d p) μ)
    (C : ℝ) (hC : 0 ≤ C)
    (hbound : ∀ p θ, ‖d p θ‖ ≤ C)
    (hcont_ae : ∀ θ, Continuous (fun p => d p θ)) :
    Continuous (fun p => ∫ θ, d p θ ∂μ) := by
  apply continuous_of_dominated
  · exact fun p => hm p
  · exact fun p => ae_of_all μ (fun θ => hbound p θ)
  · exact integrable_const C
  · exact ae_of_all μ (fun θ => hcont_ae θ)