import Mathlib

open MeasureTheory
set_option linter.unusedVariables false

theorem Claim_7_4_Pre_a {Ω : Type*} [MeasurableSpace Ω] (μ : Measure Ω) [IsProbabilityMeasure μ]
    (C A B : Set Ω) (hC : MeasurableSet C) (hA : MeasurableSet A) (hB : MeasurableSet B)
    (hA_pos : μ A ≠ 0) (hB_pos : μ B ≠ 0)
    (h_indep_A : μ (C ∩ A) = μ C * μ A) (h_indep_B : μ (C ∩ B) = μ C * μ B) :
    (μ (C ∩ A)) / μ A = (μ (C ∩ B)) / μ B := by
  have h1 : (μ (C ∩ A)) / μ A = μ C := by
    rw [h_indep_A, ENNReal.mul_div_cancel_right hA_pos (measure_ne_top μ A)]
  have h2 : (μ (C ∩ B)) / μ B = μ C := by
    rw [h_indep_B, ENNReal.mul_div_cancel_right hB_pos (measure_ne_top μ B)]
  rw [h1, h2]