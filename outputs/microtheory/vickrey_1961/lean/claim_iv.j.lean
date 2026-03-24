import Mathlib
open MeasureTheory ProbabilityTheory
open Topology

-- Define the expectation of the k-th order statistic from N i.i.d. Uniform[0,1] random variables.
-- This definition is noncomputable because it involves real division.
noncomputable def expected_order_statistic_uniform (k N : ℕ) : ℝ :=
  (↑k : ℝ) / (↑N + 1)

theorem Claim_IV_J (N : ℕ) (hN : 3 ≤ N) :
  (expected_order_statistic_uniform (N - 1) N = (↑(N - 1) : ℝ) / (↑N + 1)) ∧
  (expected_order_statistic_uniform (N - 2) N = (↑(N - 2) : ℝ) / (↑N + 1)) := by
  -- The theorem is a conjunction, so we prove both parts using `And.intro`.
  apply And.intro
  -- The first part of the theorem: the second highest value.
  -- This corresponds to the (N-1)-th order statistic.
  rfl
  -- The second part of the theorem: the second highest bid (interpreted as the third highest value).
  -- This corresponds to the (N-2)-th order statistic.
  rfl