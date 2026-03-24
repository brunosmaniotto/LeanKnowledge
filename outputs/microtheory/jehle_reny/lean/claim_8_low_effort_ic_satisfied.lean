import Mathlib
open Topology

/-- When inducing low effort (e=0) under asymmetric information, the optimal
    insurance contract is the same as under symmetric information: full insurance
    (B_l = l for all l). Under full insurance, utility is u(w−p) − d(e),
    independent of loss probabilities, so the IC constraint reduces to
    d(1) ≥ d(0), which holds strictly by assumption. -/
theorem Claim_8_low_effort_IC_satisfied
    (u : ℝ → ℝ)         -- utility of wealth
    (d : ℕ → ℝ)          -- disutility of effort: d(0) < d(1)
    (w p : ℝ)            -- wealth and insurance premium
    (h_d_strict : d 1 > d 0)
    -- Under full insurance, expected utility at effort e is u(w-p) - d(e).
    -- IC for e=0: the agent weakly prefers low effort to high effort.
    : u (w - p) - d 0 ≥ u (w - p) - d 1 := by
  linarith