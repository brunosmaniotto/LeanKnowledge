import Mathlib

open MeasureTheory

noncomputable
def charFun {Ω} [MeasurableSpace Ω] (E : Set Ω) : Ω → ℝ :=
  Set.indicator E (fun _ => (1 : ℝ))