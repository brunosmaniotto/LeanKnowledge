import Mathlib

open MeasureTheory Topology

theorem expected_utility_continuous_representation
    {Ω : Type*} [MeasurableSpace Ω] [TopologicalSpace Ω]
    (u : Ω → ℝ) (hu : Measurable u)
    (μ ν : Measure Ω) [IsProbabilityMeasure μ] [IsProbabilityMeasure ν]
    (α : ℝ) (hα0 : 0 ≤ α) (hα1 : α ≤ 1)
    (hμ : Integrable u μ) (hν : Integrable u ν) :
    ∫ x, u x ∂(ENNReal.ofReal α • μ + ENNReal.ofReal (1 - α) • ν) =
      α * ∫ x, u x ∂μ + (1 - α) * ∫ x, u x ∂ν := by
  have hα_ne : ENNReal.ofReal α ≠ ⊤ := ENNReal.ofReal_ne_top
  have h1α_ne : ENNReal.ofReal (1 - α) ≠ ⊤ := ENNReal.ofReal_ne_top
  rw [integral_add_measure (hμ.smul_measure hα_ne) (hν.smul_measure h1α_ne)]
  simp only [integral_smul_measure]
  congr 1 <;> (rw [ENNReal.toReal_ofReal (by linarith), smul_eq_mul])