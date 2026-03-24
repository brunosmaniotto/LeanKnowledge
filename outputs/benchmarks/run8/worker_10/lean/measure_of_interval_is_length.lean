import Mathlib

open Set
open MeasureTheory
open Real

theorem Measure_of_Interval_is_Length (a b : ℝ) :
    (MeasurableSet (Icc a b) ∧ volume (Icc a b) = ENNReal.ofReal (b - a)) ∧
    (MeasurableSet (Ico a b) ∧ volume (Ico a b) = ENNReal.ofReal (b - a)) ∧
    (MeasurableSet (Ioc a b) ∧ volume (Ioc a b) = ENNReal.ofReal (b - a)) ∧
    (MeasurableSet (Ioo a b) ∧ volume (Ioo a b) = ENNReal.ofReal (b - a)) := by
  exact ⟨⟨measurableSet_Icc, volume_Icc⟩,
         ⟨measurableSet_Ico, volume_Ico⟩,
         ⟨measurableSet_Ioc, volume_Ioc⟩,
         ⟨measurableSet_Ioo, volume_Ioo⟩⟩