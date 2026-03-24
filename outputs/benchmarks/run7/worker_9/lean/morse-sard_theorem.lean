import Mathlib

open Set MeasureTheory

variable {E F : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E] [FiniteDimensional ℝ E]
  [NormedAddCommGroup F] [NormedSpace ℝ F] [FiniteDimensional ℝ F]

noncomputable section

def criticalPoints (f : E → F) (hf : ContDiff ℝ ⊤ f) : Set E :=
  {x | ¬ Function.Surjective (fderiv ℝ f x)}