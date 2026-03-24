import Mathlib

open MeasureTheory ProbabilityTheory

theorem Event_Independence_is_Symmetric {Ω : Type*} [MeasurableSpace Ω] (μ : Measure Ω) {A B : Set Ω}
    (h : IndepSet A B μ) : IndepSet B A μ :=
  Indep.symm h