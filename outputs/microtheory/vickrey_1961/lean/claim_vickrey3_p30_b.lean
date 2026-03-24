import Mathlib
open MeasureTheory ProbabilityTheory Real Filter Topology
noncomputable section

-- Define the CDF for the maximum of N uniform random variables on [0,1]
def F_max_cdf (N : ℕ+) (x : ℝ) : ℝ :=
  if x < 0 then 0
  else if x > 1 then 1
  else x ^ (N : ℝ)

-- Define the PDF for the maximum of N uniform random variables on [0,1]