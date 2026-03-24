import Mathlib

open MeasureTheory

theorem Claim_6C_d (u : ℝ → ℝ) (hu : ConcaveOn ℝ Set.univ u)
    (huc : ContinuousOn u Set.univ)
    (μ : Measure ℝ) [IsProbabilityMeasure μ]
    (hu_int : Integrable u μ) (hid_int : Integrable id μ) :
    ∫ x, u x ∂μ ≤ u (∫ x, x ∂μ) := by
  have hmem : ∀ᵐ x ∂μ, x ∈ Set.univ := ae_of_all μ (fun x => Set.mem_univ x)
  have hcomp : Integrable (u ∘ id) μ := by simpa using hu_int
  exact hu.le_map_integral huc isClosed_univ hmem hid_int hcomp