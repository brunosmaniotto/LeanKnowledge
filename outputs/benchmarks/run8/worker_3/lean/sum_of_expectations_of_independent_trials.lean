import Mathlib
open MeasureTheory
open BigOperators

variable {Ω E : Type} [MeasurableSpace Ω] {μ : Measure Ω} 
  [NormedAddCommGroup E] [NormedSpace ℝ E] [CompleteSpace E]

theorem expect_sum (n : ℕ) (X : ℕ → Ω → E) (hint : ∀ j ∈ Finset.Icc 1 n, Integrable (X j) μ) :
    ∫ ω, ∑ j ∈ Finset.Icc 1 n, X j ω ∂μ = ∑ j ∈ Finset.Icc 1 n, ∫ ω, X j ω ∂μ :=
  integral_finset_sum _ hint