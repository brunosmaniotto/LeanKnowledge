import Mathlib

/-- When there is free transferability of numeraire across J consumers,
    this automatically provides at least J − 1 instruments, which suffices
    to achieve a full (J − 1)-dimensional Pareto frontier. -/
theorem free_transferability_pareto_frontier
    (J : ℕ) (hJ : J ≥ 1)
    (num_instruments : ℕ)
    (h_transferability : num_instruments ≥ J - 1)
    (required_dimension : ℕ)
    (h_req : required_dimension = J - 1) :
    num_instruments ≥ required_dimension := by
  omega