import Mathlib

open Set
open intervalIntegral
open MeasureTheory
set_option linter.unusedVariables false

theorem Claim_4_3_1_d (e q_h : ℝ → ℝ → ℝ) (p₀ p₁ v₀ CV : ℝ)
    (hCV : CV = e p₁ v₀ - e p₀ v₀)
    (hderiv : ∀ p ∈ Set.uIcc p₀ p₁, HasDerivAt (fun p' => e p' v₀) (q_h p v₀) p)
    (hcont : ContinuousOn (fun p => q_h p v₀) (Set.uIcc p₀ p₁)) :
    CV = ∫ p in p₀..p₁, q_h p v₀ := by
  have h_int : IntervalIntegrable (fun p => q_h p v₀) volume p₀ p₁ :=
    hcont.intervalIntegrable
  calc
    CV = e p₁ v₀ - e p₀ v₀ := hCV
    _ = ∫ p in p₀..p₁, q_h p v₀ := by rw [← integral_eq_sub_of_hasDerivAt hderiv h_int]