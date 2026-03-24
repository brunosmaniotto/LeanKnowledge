import Mathlib

open Finset BigOperators
open Topology
open BigOperators

-- Assume n is the number of individuals/income sources
variable {n : ℕ} [NeZero n]

-- Define income distribution y as a vector in ℝ^n
variable (y : Fin n → ℝ)

-- Define the mean of the income distribution
noncomputable def mean_income (y : Fin n → ℝ) : ℝ :=
  (∑ i : Fin n, y i) / n

-- Define a social welfare function W
-- We assume W is a continuous function from ℝ^n to ℝ.
variable (W : (Fin n → ℝ) → ℝ)

-- Define what it means for W to be homogeneous of degree 1
def IsHomogeneousOfDegree1 (W : (Fin n → ℝ) → ℝ) : Prop :=
  ∀ (c : ℝ) (hc : 0 < c) (y' : Fin n → ℝ), W (c • y') = c * W y'

-- Define what it means for W to be homothetic
-- A function W is homothetic if it can be written as G(H(y))
-- where G is strictly increasing and H is homogeneous of degree 1.
-- For this problem, the crucial part is that if W is homothetic and symmetric,
-- then properties related to homogeneity often hold or can be reduced to homogeneous cases.
-- We simplify by assuming W itself is homogeneous of degree 1, which is a common special case
-- used to derive the Blackorby-Donaldson index form.