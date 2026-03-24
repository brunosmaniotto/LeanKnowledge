import Mathlib

open Set
open scoped Real -- Enables convenient notation for real analysis concepts, including `Ioi` for open intervals.
open Topology
open Filter
open Real

/-- Implicit_Def_11C_a: Defines the structure for a public goods model
    with `I` consumers, a single public good of quantity `q`, and properties
    of consumer utility functions `φ_i(q)` and the public good cost function `c(q)`. -/
structure PublicGoodsModel where
  /-- The number of consumers in the model. Represented as a positive natural number. -/
  I : PNat
  /-- `φ i q` is consumer `i`'s derived utility from public good level `q`.
      It's a function from `PNat` (consumer index) to `(ℝ → ℝ)` (utility function). -/
  φ : PNat → (ℝ → ℝ)
  /-- `c q` is the cost of supplying `q` units of the public good.
      It's a function from `ℝ` (quantity) to `ℝ` (cost). -/
  c : ℝ → ℝ

  -- Axioms for `φ_i` (consumer utility function)
  /-- Each utility function `φ i` is twice continuously differentiable on the open interval `(0, ∞)`. -/
  φ_twice_cont_differentiable : ∀ i, ContDiffOn ℝ 2 (φ i) (Ioi 0)
  /-- The first derivative of each `φ i` is strictly positive for all `q > 0`,
      indicating that utility strictly increases with the public good level,
      characteristic of a desirable public good. -/
  φ_first_deriv_pos : ∀ i, ∀ q : ℝ, q ∈ Ioi 0 → HasDerivAt (φ i) (deriv (φ i) q) q ∧ deriv (φ i) q > 0
  /-- The second derivative of each `φ i` is strictly negative for all `q > 0`,
      indicating strict concavity of utility with respect to the public good level. -/
  φ_second_deriv_neg : ∀ i, ∀ q : ℝ, q ∈ Ioi 0 → HasDerivAt (deriv (φ i)) (deriv (deriv (φ i)) q) q ∧ deriv (deriv (φ i)) q < 0

  -- Axioms for `c` (cost function)
  /-- The cost function `c` is twice continuously differentiable on the open interval `(0, ∞)`. -/
  c_twice_cont_differentiable : ContDiffOn ℝ 2 c (Ioi 0)
  /-- The first derivative of `c` is strictly positive for all `q > 0`,
      meaning that the marginal cost of supplying the public good is always positive. -/
  c_first_deriv_pos : ∀ q : ℝ, q ∈ Ioi 0 → HasDerivAt c (deriv c q) q ∧ deriv c q > 0