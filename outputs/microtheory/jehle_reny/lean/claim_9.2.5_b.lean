import Mathlib
open BigOperators Finset
open Topology

/-- The density of the second-highest of N i.i.d. random variables with
    density f and CDF F is h(v) = N(N-1) F(v)^{N-2} f(v) (1-F(v)).
    Each of N bidders contributes (N-1)F^{N-2}f(1-F): one of N-1 others
    has a higher value, the remaining N-2 have lower values. -/
theorem second_highest_density (N : ℕ) (hN : 2 ≤ N) (F f : ℝ) :
    ∑ _i ∈ range N, ((↑(N - 1) : ℝ) * F ^ (N - 2) * f * (1 - F)) =
    (↑N : ℝ) * (↑(N - 1) : ℝ) * F ^ (N - 2) * f * (1 - F) := by
  simp only [sum_const, card_range, nsmul_eq_mul]
  ring