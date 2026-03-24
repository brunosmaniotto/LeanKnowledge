import Mathlib

open Finset BigOperators
open BigOperators

/-- A purely utilitarian Social Welfare Function (SWF) for `I` individuals.
    It has the form W(u) = Σᵢ bᵢuᵢ where bᵢ > 0. -/
structure PurelyUtilitarianSWF (I : Type*) [Fintype I] where
  /-- Positive weights for each individual -/
  weights : I → ℝ
  weights_pos : ∀ i, 0 < weights i

namespace PurelyUtilitarianSWF

variable {I : Type*} [Fintype I]

/-- The SWF value: W(u) = Σᵢ bᵢuᵢ -/
noncomputable def eval (W : PurelyUtilitarianSWF I) (u : I → ℝ) : ℝ :=
  ∑ i : I, W.weights i * u i

/-- Symmetric (equal-weight) purely utilitarian SWF: W(u) = Σᵢ uᵢ -/
noncomputable def symmetric : PurelyUtilitarianSWF I where
  weights := fun _ => 1
  weights_pos := fun _ => Real.zero_lt_one

end PurelyUtilitarianSWF