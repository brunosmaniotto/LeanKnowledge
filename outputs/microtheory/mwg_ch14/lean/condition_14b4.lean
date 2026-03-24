import Mathlib
open Topology

/-- A contract specification where the owner offers wage w_star for effort e,
    such that the manager's utility exactly equals his reservation utility. -/
theorem condition_14B4
    (v : ℝ → ℝ)           -- utility of wealth
    (g : ℝ → ℝ)           -- disutility of effort
    (e : ℝ)               -- specified effort level
    (u_bar : ℝ)           -- reservation utility
    (w_star : ℝ)          -- optimal fixed wage
    (h : v w_star - g e = u_bar) : -- contract specifies this condition
    v w_star - g e = u_bar := by
  exact h