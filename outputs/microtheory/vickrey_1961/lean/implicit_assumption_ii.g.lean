import Mathlib

open MeasureTheory Set
open Topology

/-- The uniform distribution on the unit interval (0, 1), representing the
    common value distribution in the homogeneous rectangular case. By suitable
    choice of scale and origin, any rectangular distribution can be normalized
    to this interval. -/
noncomputable def homogeneousRectangularDist : Measure ℝ :=
  volume.restrict (Ioo 0 1)

/-- The homogeneous rectangular case of a Dutch auction: n bidders whose
    individual values are all drawn from the same rectangular (uniform)
    distribution on the interval (0, 1). -/
structure HomogeneousRectangularCase (n : ℕ) (Ω : Type*) [MeasurableSpace Ω]
    (μ : Measure Ω) where
  /-- Each bidder's value as a random variable -/
  values : Fin n → Ω → ℝ
  /-- Each value function is measurable -/
  measurable_values : ∀ i, Measurable (values i)
  /-- Each individual value is marginally distributed as Uniform(0, 1) -/
  uniform_marginals : ∀ i, Measure.map (values i) μ = homogeneousRectangularDist