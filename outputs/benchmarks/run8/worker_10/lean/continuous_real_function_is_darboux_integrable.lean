import Mathlib

open Set MeasureTheory

theorem Continuous_Real_Function_is_Darboux_Integrable
    (f : ℝ → ℝ) (a b : ℝ) (hf : ContinuousOn f (uIcc a b)) :
    IntervalIntegrable f volume a b :=
  hf.intervalIntegrable