import Mathlib
open BigOperators

-- We use `def` because the Marshallian aggregate surplus is a computable scalar value.
-- It is explicitly defined by a mathematical formula involving summations and function applications,
-- which does not require non-computable features like choice or descriptions of non-constructive objects.
-- The definition directly calculates a real number based on given inputs: collections of functions and quantities.

/-- The Marshallian aggregate surplus (or simply aggregate surplus) is defined as
`S = Σ_{i=1}^I φ_i(x_i) − Σ_{j=1}^J c_j(q_j)`.
It represents the total utility generated from consumption of good ℓ less its costs of production (in terms of the numeraire).
The optimal consumption and production levels for good ℓ maximize this aggregate surplus measure. -/
def marshallianAggregateSurplus {Consumer Producer : Type*} [Fintype Consumer] [Fintype Producer]
    (φ : Consumer → (ℝ → ℝ)) (x : Consumer → ℝ)
    (c : Producer → (ℝ → ℝ)) (q : Producer → ℝ) : ℝ :=
  (∑ i : Consumer, φ i (x i)) - (∑ j : Producer, c j (q j))