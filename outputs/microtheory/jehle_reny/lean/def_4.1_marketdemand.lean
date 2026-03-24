import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- Market demand for a good: the horizontal sum of individual buyer demands.
    Given buyer `i`'s demand `q i p pbar (y i)` at own-price `p`, other-goods prices `pbar`,
    and income `y i`, market demand is `∑ i, q i p pbar (y i)`. -/
noncomputable def marketDemand
    {I : Type*} [Fintype I] {PBar : Type*}
    (q : I → ℝ → PBar → ℝ → ℝ)
    (p : ℝ) (pbar : PBar) (y : I → ℝ) : ℝ :=
  ∑ i : I, q i p pbar (y i)