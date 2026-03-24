import Mathlib
open Topology

/-- The expected wage under the optimal incentive scheme exceeds the fixed wage.
    This follows from Jensen's inequality: since v is strictly concave and w is non-constant,
    v(E[w]) > E[v(w)] = v(w*), so by strict monotonicity E[w] > w*. -/
theorem expected_wage_exceeds_fixed_wage
    {v : ℝ → ℝ} {Ew vEw w_star : ℝ}
    (hv_strict_mono : StrictMono v)
    (h_jensen : vEw < v Ew)
    (h_eq : vEw = v w_star) :
    w_star < Ew := by
  rw [h_eq] at h_jensen
  exact hv_strict_mono.lt_iff_lt.mp h_jensen