import Mathlib
open Topology

/-- A European call option on a primary asset with return vector `r ∈ ℝ^S`
at strike price `c ∈ ℝ` is an asset with return vector
`r(c) = (max{0, r₁ - c}, ..., max{0, r_S - c})`. -/
def callOptionReturn (S : ℕ) (r : Fin S → ℝ) (c : ℝ) : Fin S → ℝ :=
  fun s => max 0 (r s - c)