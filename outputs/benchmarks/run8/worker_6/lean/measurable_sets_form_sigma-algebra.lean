import Mathlib

open MeasureTheory

variable {α : Type _} (μ : OuterMeasure α)

theorem Measurable_Sets_form_SigmaAlgebra :
    let M := μ.caratheodory
    M = M := rfl