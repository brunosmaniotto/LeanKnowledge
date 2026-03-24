import Mathlib

/-- A transformation function F describing a production set Y ⊆ ℝ^L.
    Y is the sublevel set {y | F y ≤ 0}, and F y = 0 iff y lies on
    the boundary (frontier) of Y. MWG Definition 5.B. -/
structure TransformationFunction (L : ℕ) where
  /-- The transformation function F : ℝ^L → ℝ -/
  F : (Fin L → ℝ) → ℝ
  /-- F(y) = 0 if and only if y is on the boundary of the production set {y | F y ≤ 0} -/
  boundary_iff : ∀ y, F y = 0 ↔ y ∈ frontier {y : Fin L → ℝ | F y ≤ 0}

/-- The production set Y = {y ∈ ℝ^L | F(y) ≤ 0} induced by a transformation function. -/
def TransformationFunction.productionSet {L : ℕ} (tf : TransformationFunction L) :
    Set (Fin L → ℝ) :=
  {y | tf.F y ≤ 0}