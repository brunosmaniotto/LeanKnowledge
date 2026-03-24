import Mathlib

open Set

/-- A function `F` is a primitive of `f` on a set `s` if it is continuous on `s`
and has derivative `f` on the interior of `s`. -/
def IsPrimitive (F f : ℝ → ℝ) (s : Set ℝ) : Prop :=
  ContinuousOn F s ∧ ∀ x ∈ interior s, HasDerivAt F (f x) x