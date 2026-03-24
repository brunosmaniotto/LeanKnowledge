import Mathlib

open Set

/-- A function `f : Ω → ℝ` is a discrete random variable if it is measurable and has countable range.
    This matches the standard definition in probability theory. -/
def DiscreteRandomVariable {Ω : Type _} [MeasurableSpace Ω] (f : Ω → ℝ) : Prop :=
  Measurable f ∧ Set.Countable (range f)